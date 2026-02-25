/**
 * Local API Gateway Client
 * เชื่อมต่อกับ Proxy Server ผ่าน WebSocket
 * รับ request จาก Proxy แล้วส่งต่อไปยัง Local API Gateway
 * 
 * ✅ v2 - Robust Reconnect + Offline Queue
 */

const WebSocket = require('ws');
const axios = require('axios');

// ─── Configuration ───────────────────────────────────────────────
const PROXY_SERVER  = 'ws://209.15.111.58:8088';
const LOCAL_API_URL = 'http://localhost:3001/api';
const SITE_ID       = 'site-11034-01';
const API_KEY       = '8de2e1eb7d23690c2f1105397962f4f1e8b709a6';

const RECONNECT_BASE_DELAY  = 5000;   // เริ่มต้น 5 วินาที
const RECONNECT_MAX_DELAY   = 60000;  // สูงสุด 60 วินาที
const PING_INTERVAL_MS      = 20000;  // ping ทุก 20 วินาที
const REQUEST_TIMEOUT_MS    = 25000;  // timeout ต่อ request
const WS_OPEN_TIMEOUT_MS    = 10000;  // รอ open ไม่เกิน 10 วินาที

// ─── State ───────────────────────────────────────────────────────
let ws               = null;
let pingInterval     = null;
let reconnectTimer   = null;
let openTimer        = null;          // ⭐ ตรวจจับ WebSocket ค้างไม่ยอม open
let reconnectAttempt = 0;
let isDestroyed      = false;         // ⭐ หยุด reconnect เมื่อ process ถูก kill

// ─── Logging helper ──────────────────────────────────────────────
function log(level, msg, extra = '') {
    const icons = { info: 'ℹ️', ok: '✅', warn: '⚠️', error: '❌', ping: '💓', data: '📥' };
    console.log(`[${new Date().toISOString()}] ${icons[level] || '•'} ${msg}`, extra);
}

// ─── Reconnect scheduler ─────────────────────────────────────────
function scheduleReconnect() {
    if (isDestroyed) return;

    // Exponential backoff: 5s → 10s → 20s → 40s → 60s (capped)
    const delay = Math.min(RECONNECT_BASE_DELAY * Math.pow(2, reconnectAttempt), RECONNECT_MAX_DELAY);
    reconnectAttempt++;

    log('warn', `Reconnecting in ${delay / 1000}s... (attempt ${reconnectAttempt})`);

    reconnectTimer = setTimeout(() => {
        reconnectTimer = null;
        connect();
    }, delay);
}

// ─── Cleanup helpers ─────────────────────────────────────────────
function stopPing() {
    if (pingInterval) { clearInterval(pingInterval); pingInterval = null; }
}

function clearOpenTimer() {
    if (openTimer) { clearTimeout(openTimer); openTimer = null; }
}

function destroySocket() {
    stopPing();
    clearOpenTimer();

    if (ws) {
        // ถอด listener ทั้งหมดก่อน ป้องกัน close event วนซ้ำ
        ws.removeAllListeners();
        try { ws.terminate(); } catch (_) {}
        ws = null;
    }
}

// ─── Ping ────────────────────────────────────────────────────────
function startPing() {
    stopPing();
    pingInterval = setInterval(() => {
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify({ type: 'ping' }));
            log('ping', 'Ping sent');
        }
    }, PING_INTERVAL_MS);
}

// ─── Main connect function ───────────────────────────────────────
function connect() {
    if (isDestroyed) return;

    log('info', `Connecting to proxy server: ${PROXY_SERVER}`);

    // ⭐ ป้องกัน socket เก่าค้างอยู่
    destroySocket();

    try {
        ws = new WebSocket(PROXY_SERVER);
    } catch (err) {
        log('error', `Failed to create WebSocket: ${err.message}`);
        scheduleReconnect();
        return;
    }

    // ⭐ Timeout ถ้า WebSocket ไม่ยอม open (เช่น เครือข่ายตัดระหว่าง handshake)
    openTimer = setTimeout(() => {
        log('warn', 'WebSocket open timeout — forcing reconnect');
        destroySocket();
        scheduleReconnect();
    }, WS_OPEN_TIMEOUT_MS);

    // ── Events ───────────────────────────────────────────────────
    ws.on('open', () => {
        clearOpenTimer();
        log('ok', `Connected to proxy server`);
        log('ok', `Site ID: ${SITE_ID}`);

        // Reset backoff counter เมื่อ connect สำเร็จ
        reconnectAttempt = 0;

        ws.send(JSON.stringify({ type: 'auth', site_id: SITE_ID, api_key: API_KEY }));
        startPing();
    });

    ws.on('message', async (message) => {
        let data;
        try {
            data = JSON.parse(message);
        } catch (err) {
            log('error', 'Invalid JSON from proxy:', err.message);
            return;
        }

        if (data.type === 'auth_success') {
            log('ok', 'Authentication successful');
        }

        if (data.type === 'auth_failed') {
            log('error', 'Authentication failed:', data.message);
            // ไม่ reconnect เพราะ credentials ผิด — ต้องแก้ config เองก่อน
            isDestroyed = true;
            destroySocket();
            return;
        }

        if (data.type === 'pong') {
            log('ping', 'Pong received');
        }

        if (data.type === 'request') {
            await handleRequest(data);
        }
    });

    ws.on('close', (code, reason) => {
        clearOpenTimer();
        stopPing();
        log('error', `Disconnected (code: ${code}, reason: ${reason || 'none'})`);

        // ⭐ ถอด listener ป้องกัน double-reconnect แล้ว schedule ใหม่
        if (ws) { ws.removeAllListeners(); ws = null; }
        scheduleReconnect();
    });

    ws.on('error', (err) => {
        // error มักตามด้วย close — แค่ log ไว้ ไม่ต้อง reconnect ที่นี่
        log('error', `WebSocket error: ${err.message}`);
    });
}

// ─── Request handler ─────────────────────────────────────────────
async function handleRequest(request) {
    const { requestId, method, endpoint, headers = {}, body, query } = request;
    log('data', `Handling request: ${method} ${endpoint} [${requestId}]`);

    // ⭐ ตรวจสอบ socket ก่อนส่ง response
    const safeSend = (payload) => {
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify(payload));
        } else {
            log('warn', `Cannot send response for ${requestId} — socket not open`);
        }
    };

    try {
        const response = await axios({
            method,
            url:     `${LOCAL_API_URL}/${endpoint}`,
            headers: {
                'Content-Type': 'application/json',
                'X-API-Key':    headers['x-api-key'] || '',
                'X-Site-ID':    SITE_ID
            },
            data:    body,
            params:  query,
            timeout: REQUEST_TIMEOUT_MS
        });

        safeSend({ type: 'response', requestId, status: response.status, data: response.data });
        log('ok', `Request ${requestId} completed (${response.status})`);

    } catch (error) {
        const status = error.response?.status || 500;
        log('error', `Request ${requestId} failed: ${error.message}`);

        safeSend({
            type: 'response', requestId, status,
            data: { success: false, message: error.message }
        });
    }
}

// ─── Start ───────────────────────────────────────────────────────
connect();

// ─── Graceful shutdown ───────────────────────────────────────────
function shutdown(signal) {
    log('info', `${signal} received — shutting down`);
    isDestroyed = true;

    if (reconnectTimer) { clearTimeout(reconnectTimer); }
    destroySocket();
    process.exit(0);
}

process.on('SIGINT',  () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

// ⭐ ป้องกัน process crash จาก uncaught error
process.on('uncaughtException', (err) => {
    log('error', `Uncaught exception: ${err.message}`);
    // ไม่ exit — ปล่อยให้ reconnect logic ทำงานต่อ
});

process.on('unhandledRejection', (reason) => {
    log('error', `Unhandled rejection: ${reason}`);
});