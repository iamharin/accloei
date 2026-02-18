/**
 * Local API Gateway Client
 * เชื่อมต่อกับ Proxy Server ผ่าน WebSocket
 * รับ request จาก Proxy แล้วส่งต่อไปยัง Local API Gateway
 */

const WebSocket = require('ws');
const axios = require('axios');
const dotenv = require('dotenv');

dotenv.config();

// Configuration
const PROXY_SERVER = process.env.PROXY_SERVER || 'ws://209.15.111.58:8088';
const LOCAL_API_URL = process.env.LOCAL_API_URL || 'http://localhost:3001/api';
const SITE_ID = process.env.SITE_ID;
const API_KEY = process.env.API_KEY;

// Validate required env vars
if (!SITE_ID || !API_KEY) {
    console.error('❌ Missing required environment variables: SITE_ID, API_KEY');
    console.error('   Please check your .env file');
    process.exit(1);
}

let ws = null;
let reconnectInterval = 5000;
let reconnectAttempts = 0;
let maxReconnectInterval = 60000; // Max 1 minute
let pingInterval = null;

function connect() {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] 🔌 Connecting to proxy server: ${PROXY_SERVER}`);
    
    ws = new WebSocket(PROXY_SERVER);
    
    ws.on('open', () => {
        console.log('✅ Connected to proxy server');
        console.log(`   Site ID: ${SITE_ID}`);
        
        // Reset reconnect attempts on successful connection
        reconnectAttempts = 0;
        reconnectInterval = 5000;
        
        // Authenticate
        ws.send(JSON.stringify({
            type: 'auth',
            site_id: SITE_ID,
            api_key: API_KEY
        }));
        
        // Start ping
        startPing();
    });
    
    ws.on('message', async (message) => {
        try {
            const data = JSON.parse(message);
            
            if (data.type === 'auth_success') {
                console.log('✅ Authentication successful');
            }
            
            if (data.type === 'auth_failed') {
                console.error('❌ Authentication failed:', data.message);
                ws.close();
                return;
            }
            
            if (data.type === 'pong') {
                console.log('💓 Pong received');
            }
            
            if (data.type === 'request') {
                await handleRequest(data);
            }
            
        } catch (error) {
            console.error('Message handling error:', error);
        }
    });
    
    ws.on('close', () => {
        console.log('❌ Disconnected from proxy server');
        stopPing();
        
        // Exponential backoff for reconnection
        reconnectAttempts++;
        const delay = Math.min(reconnectInterval * Math.pow(2, reconnectAttempts - 1), maxReconnectInterval);
        
        console.log(`🔄 Reconnecting in ${delay/1000}s... (attempt ${reconnectAttempts})`);
        
        setTimeout(() => {
            connect();
        }, delay);
    });
    
    ws.on('error', (error) => {
        console.error('WebSocket error:', error);
    });
}

async function handleRequest(request) {
    const { requestId, method, endpoint, headers, body, query } = request;
    
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] 📥 Handling request: ${method} ${endpoint}`);
    
    try {
        // ส่ง request ไปยัง Local API Gateway
        const response = await axios({
            method: method,
            url: `${LOCAL_API_URL}/${endpoint}`,
            headers: {
                'Content-Type': 'application/json',
                'X-API-Key': headers['x-api-key'],
                'X-Site-ID': SITE_ID
            },
            data: body,
            params: query,
            timeout: 25000 // ⭐ เพิ่ม timeout เพื่อป้องกัน request ค้าง
        });
        
        // ส่ง response กลับไปยัง Proxy Server
        ws.send(JSON.stringify({
            type: 'response',
            requestId: requestId,
            status: response.status,
            data: response.data
        }));
        
        console.log(`[${timestamp}] ✅ Request ${requestId} completed (${response.status})`);
        
    } catch (error) {
        console.error(`[${timestamp}] ❌ Request ${requestId} failed:`, error.message);
        
        // ส่ง error response
        ws.send(JSON.stringify({
            type: 'response',
            requestId: requestId,
            status: error.response?.status || 500,
            data: {
                success: false,
                message: error.message
            }
        }));
    }
}

function startPing() {
    pingInterval = setInterval(() => {
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify({ type: 'ping' }));
            console.log('💓 Ping sent');
        }
    }, 20000); // ⭐ เปลี่ยนเป็น 20 วินาที (ก่อน server timeout 30s)
}

function stopPing() {
    if (pingInterval) {
        clearInterval(pingInterval);
        pingInterval = null;
    }
}

// Start connection
connect();

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('Shutting down...');
    stopPing();
    if (ws) {
        ws.close();
    }
    process.exit(0);
});