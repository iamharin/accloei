// server.js - Optimized Version
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const winston = require('winston');
const dotenv = require('dotenv');
const crypto = require('crypto');

dotenv.config();

const app = express();

// ⭐ เพิ่ม Request Timeout
app.use((req, res, next) => {
    req.setTimeout(60000); // 60 วินาที
    res.setTimeout(60000);
    next();
});

// Middleware
app.use(helmet());
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://209.15.111.58'],
    credentials: true
}));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Logger
const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/combined.log' }),
        new winston.transports.Console({
            format: winston.format.simple()
        })
    ]
});

// Rate Limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 10000,
    // ⭐ เพิ่มส่วนนี้ - Skip rate limit สำหรับ IP ที่เชื่อถือได้
    skip: (req) => {
        const trustedIPs = [
            '192.168.1.200',  // ⭐ ใส่ IP ของ client ตรงนี้
            '192.168.1.201',
            '127.0.0.1',
            '::1'
        ];
        return trustedIPs.includes(req.ip);
    }
});
app.use('/api/', limiter);

// ⭐ Database Configuration - เพิ่ม connectionLimit และ timeout
const dbConfig = {
    ar_management: {
        host: process.env.DB_HOST || '192.168.1.211',
        user: process.env.DB_USER || 'sa',
        password: process.env.DB_PASS || 'sibomiN',
        database: process.env.DB_NAME || 'ar_management',
        waitForConnections: true,
        connectionLimit: 50,  // ⭐ เพิ่มจาก 10 เป็น 50
        queueLimit: 0,
        charset: 'utf8mb4',
        connectTimeout: 10000,      // ⭐ เพิ่ม connect timeout
        acquireTimeout: 10000,      // ⭐ เพิ่ม acquire timeout
        timeout: 60000,             // ⭐ เพิ่ม query timeout
        enableKeepAlive: true,      // ⭐ เพิ่ม keep alive
        keepAliveInitialDelay: 0
    },
    hosxp: {
        host: process.env.HOSXP_HOST || '192.168.1.200',
        user: process.env.HOSXP_USER || '11034',
        password: process.env.HOSXP_PASS || '11034',
        database: process.env.HOSXP_NAME || 'hos',
        waitForConnections: true,
        connectionLimit: 50,  // ⭐ เพิ่มจาก 10 เป็น 50
        queueLimit: 0,
        charset: 'utf8mb4',
        connectTimeout: 10000,
        acquireTimeout: 10000,
        timeout: 60000,
        enableKeepAlive: true,
        keepAliveInitialDelay: 0
    }
};

// Create connection pools
const pools = {
    ar_management: mysql.createPool(dbConfig.ar_management),
    hosxp: mysql.createPool(dbConfig.hosxp)
};

pools.ar_management.on('connection', (connection) => {
    connection.query('SET NAMES utf8mb4');
    connection.query('SET CHARACTER SET utf8mb4');
    connection.query('SET character_set_connection=utf8mb4');
});

pools.hosxp.on('connection', (connection) => {
    connection.query('SET NAMES utf8mb4');
    connection.query('SET CHARACTER SET utf8mb4');
    connection.query('SET character_set_connection=utf8mb4');
});

// ⭐ เพิ่ม Connection Pool Monitoring
setInterval(async () => {
    try {
        const arPool = await pools.ar_management.pool;
        const hosxpPool = await pools.hosxp.pool;
        logger.info('Pool Stats', {
            ar_management: {
                all: arPool._allConnections.length,
                free: arPool._freeConnections.length,
                queue: arPool._connectionQueue.length
            },
            hosxp: {
                all: hosxpPool._allConnections.length,
                free: hosxpPool._freeConnections.length,
                queue: hosxpPool._connectionQueue.length
            }
        });
    } catch (error) {
        logger.error('Pool monitoring error:', error.message);
    }
}, 30000); // ทุก 30 วินาที

// Middleware สำหรับตรวจสอบ API Key
const validateApiKey = async (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    const siteId = req.headers['x-site-id'];
    
    if (!apiKey || !siteId) {
        return res.status(401).json({
            success: false,
            message: 'API Key and Site ID are required'
        });
    }

    const expectedKey = process.env.API_KEY;
    const expectedSiteId = process.env.SITE_ID;
    const expectedHcode = process.env.HCODE;

    if (apiKey !== expectedKey || siteId !== expectedSiteId) {
        logger.warn('Invalid API Key attempt', { apiKey, siteId, ip: req.ip });
        return res.status(403).json({
            success: false,
            message: 'Invalid API Key or Site ID'
        });
    }

    req.siteId = siteId;
    req.hcode = expectedHcode;
    next();
};

// Health Check
app.get('/health', (req, res) => {
    res.json({
        success: true,
        message: 'API Gateway is running',
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// ===========================================
// Authentication APIs
// ===========================================

app.post('/api/auth/login', validateApiKey, async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({
                success: false,
                message: 'Username and password are required'
            });
        }

        const [users] = await pools.ar_management.query(
            `SELECT user_id, username, password, full_name, role, is_active 
             FROM users 
             WHERE username = ? AND is_active = 1`,
            [username]
        );

        if (users.length === 0) {
            logger.warn('Login attempt with invalid username', { username, ip: req.ip });
            return res.status(401).json({
                success: false,
                message: 'Invalid username or password'
            });
        }

        const user = users[0];
        
        const crypto = require('crypto');
        const inputHash = crypto.createHash('sha256').update(password).digest('hex');

        await pools.ar_management.query(
            `INSERT INTO activity_logs (user_id, action, ip_address) 
             VALUES (?, 'เข้าสู่ระบบผ่าน API', ?)`,
            [user.user_id, req.ip]
        );

        logger.info('User logged in', { userId: user.user_id, username });

        res.json({
            success: true,
            data: {
                user_id: user.user_id,
                username: user.username,
                full_name: user.full_name,
                role: user.role
            }
        });

    } catch (error) {
        logger.error('Login error:', error);
        res.status(500).json({
            success: false,
            message: 'Internal server error',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
});

app.post('/api/auth/logout', validateApiKey, async (req, res) => {
    try {
        const { user_id } = req.body;

        if (user_id) {
            await pools.ar_management.query(
                `INSERT INTO activity_logs (user_id, action, ip_address) 
                 VALUES (?, 'ออกจากระบบ', ?)`,
                [user_id, req.ip]
            );
        }

        res.json({
            success: true,
            message: 'Logged out successfully'
        });

    } catch (error) {
        logger.error('Logout error:', error);
        res.status(500).json({
            success: false,
            message: 'Internal server error'
        });
    }
});

// ===========================================
// ⭐ OPTIMIZED HOSxP Data Import API
// ===========================================

app.post('/api/hosxp/import-ar', validateApiKey, async (req, res) => {
    const connection = await pools.ar_management.getConnection();
    
    try {
        const { start_date, end_date, pttype, user_id } = req.body;

        if (!start_date || !end_date) {
            connection.release();
            return res.status(400).json({
                success: false,
                message: 'Start date and end date are required'
            });
        }

        // ⭐ เริ่ม transaction
        await connection.beginTransaction();

        // ดึงข้อมูลจาก HOSxP
        const hosxpQuery = `
            SELECT 
                v.hn,
                v.vn,
                v.an,
                v.vstdate as service_date,
                v.vsttime,
                p.cid,
                CONCAT(p.pname, p.fname, ' ', p.lname) as patient_name,
                v.pttype,
                pt.name as pttype_name,
                o.icode,
                o.qty,
                o.unitprice,
                o.sum_price,
                d.diagtype,
                d.icd10 as diag_code,
                i.name as diag_name,
                a.dchdate as discharge_date,
                a.admdate
            FROM vn_stat v
            LEFT JOIN patient p ON v.hn = p.hn
            LEFT JOIN pttype pt ON v.pttype = pt.pttype
            LEFT JOIN opitemrece o ON v.vn = o.vn
            LEFT JOIN ovstdiag d ON v.vn = d.vn AND d.diagtype = 1
            LEFT JOIN icd101 i ON d.icd10 = i.code
            LEFT JOIN ipt a ON v.an = a.an
            WHERE v.vstdate BETWEEN ? AND ?
            ${pttype ? 'AND v.pttype = ?' : ''}
            ORDER BY v.vstdate, v.vn
        `;

        const params = pttype ? [start_date, end_date, pttype] : [start_date, end_date];
        const [hosxpData] = await pools.hosxp.query(hosxpQuery, params);

        if (hosxpData.length === 0) {
            await connection.rollback();
            connection.release();
            return res.json({
                success: true,
                message: 'No data found for import',
                data: { imported: 0, skipped: 0, total: 0 }
            });
        }

        // จัดกลุ่มข้อมูลตาม VN
        const groupedData = {};
        hosxpData.forEach(row => {
            const key = row.vn;
            if (!groupedData[key]) {
                groupedData[key] = {
                    hn: row.hn,
                    vn: row.vn,
                    an: row.an,
                    cid: row.cid,
                    patient_name: row.patient_name,
                    service_date: row.service_date,
                    discharge_date: row.discharge_date,
                    pttype: row.pttype,
                    pttype_name: row.pttype_name,
                    diag_code: row.diag_code,
                    diag_name: row.diag_name,
                    total_amount: 0,
                    items: []
                };
            }
            
            if (row.sum_price) {
                groupedData[key].total_amount += parseFloat(row.sum_price);
                groupedData[key].items.push({
                    icode: row.icode,
                    qty: row.qty,
                    unitprice: row.unitprice,
                    sum_price: row.sum_price
                });
            }
        });

        // ⭐ Optimization 1: ดึง existing VNs ทั้งหมดครั้งเดียว
        const vnList = Object.keys(groupedData);
        const placeholders = vnList.map(() => '?').join(',');
        const [existingRecords] = await connection.query(
            `SELECT vn FROM accounts_receivable WHERE vn IN (${placeholders})`,
            vnList
        );
        const existingVNs = new Set(existingRecords.map(r => r.vn));

        // ⭐ Optimization 2: ดึง COA mapping ทั้งหมดครั้งเดียว
        const pttypes = [...new Set(Object.values(groupedData).map(d => d.pttype))];
        const [coaRecords] = await connection.query(
            `SELECT pttype, coa_id FROM chart_of_accounts 
             WHERE pttype IN (${pttypes.map(() => '?').join(',')})`,
            pttypes
        );
        const coaMap = {};
        coaRecords.forEach(r => {
            coaMap[r.pttype] = r.coa_id;
        });

        // ⭐ Optimization 3: Generate AR numbers ล่วงหน้า
        const year = new Date().getFullYear();
        const month = String(new Date().getMonth() + 1).padStart(2, '0');
        const prefix = `AR${year}${month}`;
        
        const [maxArResult] = await connection.query(
            `SELECT MAX(CAST(SUBSTRING(ar_number, -5) AS UNSIGNED)) as max_num 
             FROM accounts_receivable 
             WHERE ar_number LIKE ?`,
            [`${prefix}%`]
        );
        
        let nextNum = (maxArResult[0].max_num || 0) + 1;

        // ⭐ Optimization 4: Prepare batch insert data
        const valuesToInsert = [];
        const paramsToInsert = [];
        let imported = 0;
        let skipped = 0;

        for (const vn in groupedData) {
            const data = groupedData[vn];
            
            // ข้าม record ที่มีอยู่แล้ว
            if (existingVNs.has(data.vn)) {
                skipped++;
                continue;
            }

            const coa_id = coaMap[data.pttype] || 1;
            const ar_number = `${prefix}${String(nextNum).padStart(5, '0')}`;
            nextNum++;

            valuesToInsert.push(
                '(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
            );
            
            paramsToInsert.push(
                ar_number,
                coa_id,
                data.pttype,
                data.hn,
                data.vn,
                data.cid,
                data.an,
                data.patient_name,
                data.service_date,
                data.discharge_date,
                data.total_amount,
                data.total_amount,
                data.total_amount,
                'pending',
                'draft',
                user_id,
                data.diag_code ? `${data.diag_code}: ${data.diag_name}` : null
            );
            
            imported++;
        }

        // ⭐ Optimization 5: Bulk insert แทน insert ทีละ record
        if (valuesToInsert.length > 0) {
            // แบ่ง batch ถ้าข้อมูลเยอะมาก (ทีละ 500 records)
            const BATCH_SIZE = 500;
            for (let i = 0; i < valuesToInsert.length; i += BATCH_SIZE) {
                const batchValues = valuesToInsert.slice(i, i + BATCH_SIZE);
                const batchParams = paramsToInsert.slice(i * 17, (i + BATCH_SIZE) * 17);
                
                const insertQuery = `
                    INSERT INTO accounts_receivable 
                    (ar_number, coa_id, pttype, hn, vn, cid, an, patient_name, 
                     service_date, discharge_date, total_amount, ar_amount, balance, 
                     status, submission_status, created_by, diag_list)
                    VALUES ${batchValues.join(', ')}
                `;
                
                await connection.query(insertQuery, batchParams);
            }
        }

        // Log activity
        if (user_id) {
            await connection.query(
                `INSERT INTO activity_logs (user_id, action, new_data, ip_address)
                 VALUES (?, 'นำเข้าข้อมูล AR จาก HOSxP', ?, ?)`,
                [user_id, JSON.stringify({ 
                    imported, 
                    skipped, 
                    date_range: `${start_date} - ${end_date}` 
                }), req.ip]
            );
        }

        await connection.commit();
        logger.info('AR Import completed', { imported, skipped, total: imported + skipped });

        res.json({
            success: true,
            message: 'Import completed successfully',
            data: {
                imported,
                skipped,
                total: imported + skipped
            }
        });

    } catch (error) {
        await connection.rollback();
        logger.error('Import AR error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to import data',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    } finally {
        connection.release();
    }
});

app.get('/api/hosxp/patient/:hn', validateApiKey, async (req, res) => {
    try {
        const { hn } = req.params;

        const [patient] = await pools.hosxp.query(
            `SELECT 
                p.hn,
                p.cid,
                CONCAT(p.pname, p.fname, ' ', p.lname) as full_name,
                p.birthday,
                p.sex,
                p.addrpart,
                p.moopart,
                p.tmbpart,
                p.amppart,
                p.chwpart
            FROM patient p
            WHERE p.hn = ?`,
            [hn]
        );

        if (patient.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Patient not found'
            });
        }

        res.json({
            success: true,
            data: patient[0]
        });

    } catch (error) {
        logger.error('Get patient error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to get patient data'
        });
    }
});

// ===========================================
// AR Management APIs
// ===========================================

app.get('/api/ar', validateApiKey, async (req, res) => {
    try {
        const { 
            status, 
            pttype, 
            start_date, 
            end_date,
            page = 1,
            limit = 50,
            search
        } = req.query;

        let whereConditions = [];
        let params = [];

        if (status) {
            whereConditions.push('ar.status = ?');
            params.push(status);
        }

        if (pttype) {
            whereConditions.push('ar.pttype = ?');
            params.push(pttype);
        }

        if (start_date && end_date) {
            whereConditions.push('ar.service_date BETWEEN ? AND ?');
            params.push(start_date, end_date);
        }

        if (search) {
            whereConditions.push('(ar.hn LIKE ? OR ar.vn LIKE ? OR ar.patient_name LIKE ? OR ar.ar_number LIKE ?)');
            const searchTerm = `%${search}%`;
            params.push(searchTerm, searchTerm, searchTerm, searchTerm);
        }

        const whereClause = whereConditions.length > 0 
            ? `WHERE ${whereConditions.join(' AND ')}` 
            : '';

        // Count total
        const [countResult] = await pools.ar_management.query(
            `SELECT COUNT(*) as total FROM accounts_receivable ar ${whereClause}`,
            params
        );

        const total = countResult[0].total;
        const offset = (page - 1) * limit;

        // Get data
        const [data] = await pools.ar_management.query(
            `SELECT 
                ar.*,
                coa.account_name,
                u.full_name as created_by_name
            FROM accounts_receivable ar
            LEFT JOIN chart_of_accounts coa ON ar.coa_id = coa.coa_id
            LEFT JOIN users u ON ar.created_by = u.user_id
            ${whereClause}
            ORDER BY ar.created_at DESC
            LIMIT ? OFFSET ?`,
            [...params, parseInt(limit), offset]
        );

        res.json({
            success: true,
            data: {
                items: data,
                pagination: {
                    total,
                    page: parseInt(page),
                    limit: parseInt(limit),
                    totalPages: Math.ceil(total / limit)
                }
            }
        });

    } catch (error) {
        logger.error('Get AR list error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to get AR data'
        });
    }
});

app.get('/api/ar/:id', validateApiKey, async (req, res) => {
    try {
        const { id } = req.params;

        const [data] = await pools.ar_management.query(
            `SELECT 
                ar.*,
                coa.account_code,
                coa.account_name,
                u.full_name as created_by_name,
                u2.full_name as approved_by_name
            FROM accounts_receivable ar
            LEFT JOIN chart_of_accounts coa ON ar.coa_id = coa.coa_id
            LEFT JOIN users u ON ar.created_by = u.user_id
            LEFT JOIN users u2 ON ar.approved_by = u2.user_id
            WHERE ar.ar_id = ?`,
            [id]
        );

        if (data.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'AR not found'
            });
        }

        res.json({
            success: true,
            data: data[0]
        });

    } catch (error) {
        logger.error('Get AR detail error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to get AR detail'
        });
    }
});

app.post('/api/query', validateApiKey, async (req, res) => {
    try {
        const { database, query, params = [] } = req.body;

        const queryType = query.trim().toUpperCase().split(/\s+/)[0];
        const allowedQueries = ['SELECT', 'INSERT', 'UPDATE', 'DELETE'];
        
        if (!allowedQueries.includes(queryType)) {
            return res.status(403).json({
                success: false,
                message: 'Query type not allowed. Allowed: SELECT, INSERT, UPDATE, DELETE'
            });
        }

        if (!pools[database]) {
            return res.status(400).json({
                success: false,
                message: 'Invalid database'
            });
        }

        const [results] = await pools[database].query(query, params);

        res.json({
            success: true,
            data: results
        });

    } catch (error) {
        logger.error('Query execution error:', error);
        res.status(500).json({
            success: false,
            message: 'Query execution failed',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
});

// ===========================================
// Migrate API (DDL สำหรับ Auto Migration)
// ===========================================

app.post('/api/migrate', validateApiKey, async (req, res) => {
    try {
        const { database, statements } = req.body;

        if (database !== 'ar_management') {
            return res.status(403).json({ success: false, message: 'migrate endpoint รองรับเฉพาะ ar_management' });
        }

        if (!Array.isArray(statements) || statements.length === 0) {
            return res.status(400).json({ success: false, message: 'Required: statements (array)' });
        }

        const ALLOWED = [
            /^\s*CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS/i,
            /^\s*CREATE\s+OR\s+REPLACE\s+VIEW/i,
            /^\s*ALTER\s+TABLE\s+.+ADD\s+COLUMN/i,
            /^\s*ALTER\s+TABLE\s+.+ADD\s+(UNIQUE\s+)?INDEX/i,
            /^\s*INSERT\s+INTO\s+`?schema_migrations`?/i,
            /^\s*DELETE\s+FROM\s+`?schema_migrations`?/i,
            /^\s*SELECT\s+.+FROM\s+`?schema_migrations`?/i,
            /^\s*SELECT\s+COUNT\(.+\).+INFORMATION_SCHEMA/i,
            /^\s*SELECT\s+COUNT\(.+\).+STATISTICS/i,
        ];

        const BLOCKED = [/DROP\s+TABLE/i, /DROP\s+DATABASE/i, /TRUNCATE/i];

        for (const sql of statements) {
            const trimmed = sql.trim();
            if (!trimmed) continue;
            for (const blocked of BLOCKED) {
                if (blocked.test(trimmed)) {
                    logger.warn('Blocked DDL attempt', { sql: trimmed.substring(0, 100), ip: req.ip });
                    return res.status(403).json({ success: false, message: `ไม่อนุญาต: ${trimmed.substring(0, 60)}...` });
                }
            }
            if (!ALLOWED.some(p => p.test(trimmed))) {
                return res.status(403).json({ success: false, message: `ไม่อยู่ใน whitelist: ${trimmed.substring(0, 60)}...` });
            }
        }

        const results = [];
        for (const sql of statements) {
            const trimmed = sql.trim();
            if (!trimmed) continue;
            try {
                await pools.ar_management.query(trimmed);
                results.push({ success: true, sql: trimmed.substring(0, 80) + (trimmed.length > 80 ? '...' : '') });
            } catch (err) {
                const ignorable = ['Duplicate column name', 'already exists', 'Duplicate key name'];
                const isIgnorable = ignorable.some(msg => err.message.includes(msg));
                results.push({ success: isIgnorable, skipped: isIgnorable, sql: trimmed.substring(0, 80) + '...', error: err.message });
                if (!isIgnorable) {
                    logger.error('Migrate statement failed:', { error: err.message });
                    return res.status(500).json({ success: false, message: err.message, results });
                }
            }
        }

        logger.info('Migration executed', { count: results.length, ip: req.ip });
        res.json({ success: true, results });

    } catch (error) {
        logger.error('Migrate endpoint error:', error);
        res.status(500).json({ success: false, message: 'Migration failed' });
    }
});

// ===========================================
// Activity Logs API
// ===========================================

app.post('/api/activity-logs', validateApiKey, async (req, res) => {
    try {
        const { user_id, action, table_name, record_id, old_data, new_data, ip_address } = req.body;

        if (!action) {
            return res.status(400).json({ success: false, message: 'action is required' });
        }

        const [result] = await pools.ar_management.query(
            `INSERT INTO activity_logs 
             (user_id, action, table_name, record_id, old_data, new_data, ip_address)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                user_id   || null,
                action,
                table_name || null,
                record_id  || null,
                old_data   || null,
                new_data   || null,
                ip_address || req.ip
            ]
        );

        res.json({ success: true, data: { log_id: result.insertId } });

    } catch (error) {
        // ถ้า column ไม่มีใน table ให้ลอง INSERT แบบ minimal แทน
        try {
            const { user_id, action, ip_address } = req.body;
            await pools.ar_management.query(
                `INSERT INTO activity_logs (user_id, action, ip_address) VALUES (?, ?, ?)`,
                [user_id || null, action || 'unknown', ip_address || req.ip]
            );
            res.json({ success: true });
        } catch (fallbackError) {
            logger.error('Activity log error:', fallbackError);
            // ไม่ crash แอป — log แล้วตอบ success เสมอ
            res.json({ success: true });
        }
    }
});

app.get('/api/activity-logs', validateApiKey, async (req, res) => {
    try {
        const { user_id, limit = 50, page = 1 } = req.query;
        const offset = (page - 1) * limit;

        let where = '';
        let params = [];
        if (user_id) {
            where = 'WHERE user_id = ?';
            params.push(user_id);
        }

        const [rows] = await pools.ar_management.query(
            `SELECT * FROM activity_logs ${where} ORDER BY created_at DESC LIMIT ? OFFSET ?`,
            [...params, parseInt(limit), offset]
        );

        res.json({ success: true, data: rows });

    } catch (error) {
        logger.error('Get activity logs error:', error);
        res.status(500).json({ success: false, message: 'Failed to get activity logs' });
    }
});

// ===========================================
// Notifications API
// ===========================================

app.post('/api/notifications', validateApiKey, async (req, res) => {
    try {
        const { user_id, role, title, message, type = 'info', reference_type, reference_id, action_url, created_by } = req.body;

        if (!title || !message) {
            return res.status(400).json({ success: false, message: 'title and message are required' });
        }

        const [result] = await pools.ar_management.query(
            `INSERT INTO notifications 
             (user_id, role, title, message, type, reference_type, reference_id, action_url, created_by, is_read, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, NOW())`,
            [user_id || null, role || null, title, message, type, reference_type || null, reference_id || null, action_url || null, created_by || null]
        );

        res.json({ success: true, data: { notification_id: result.insertId } });

    } catch (error) {
        logger.error('Create notification error:', error);
        res.status(500).json({ success: false, message: 'Failed to create notification' });
    }
});

app.get('/api/notifications', validateApiKey, async (req, res) => {
    try {
        const { user_id, role, is_read, limit = 10 } = req.query;

        let conditions = [];
        let params = [];

        if (user_id) { conditions.push('(user_id = ? OR user_id IS NULL)'); params.push(user_id); }
        if (role)    { conditions.push('(role = ? OR role IS NULL)');       params.push(role); }
        if (is_read !== undefined) { conditions.push('is_read = ?');        params.push(parseInt(is_read)); }

        const where = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

        const [rows] = await pools.ar_management.query(
            `SELECT * FROM notifications ${where} ORDER BY created_at DESC LIMIT ?`,
            [...params, parseInt(limit)]
        );

        res.json({ success: true, data: { items: rows } });

    } catch (error) {
        logger.error('Get notifications error:', error);
        res.status(500).json({ success: false, message: 'Failed to get notifications' });
    }
});

app.put('/api/notifications/:id', validateApiKey, async (req, res) => {
    try {
        const { id } = req.params;
        const { is_read, read_by } = req.body;

        await pools.ar_management.query(
            `UPDATE notifications SET is_read = ?, read_at = NOW(), read_by = ? WHERE notification_id = ?`,
            [is_read ? 1 : 0, read_by || null, id]
        );

        res.json({ success: true });

    } catch (error) {
        logger.error('Update notification error:', error);
        res.status(500).json({ success: false, message: 'Failed to update notification' });
    }
});

// ===========================================
// Error Handling
// ===========================================

app.use((err, req, res, next) => {
    logger.error('Unhandled error:', err);
    res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});

app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Endpoint not found'
    });
});

// Start Server
const PORT = process.env.PORT || 3001;
const server = app.listen(PORT, '0.0.0.0', () => {
    logger.info(`API Gateway running on port ${PORT}`);
    console.log(`🚀 API Gateway running on port ${PORT}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

// ⭐ เพิ่ม Server Timeout
server.setTimeout(120000); // 2 นาที

// Graceful Shutdown
process.on('SIGTERM', async () => {
    logger.info('SIGTERM received, closing server...');
    server.close(() => {
        logger.info('HTTP server closed');
    });
    await pools.ar_management.end();
    await pools.hosxp.end();
    process.exit(0);
});

process.on('SIGINT', async () => {
    logger.info('SIGINT received, closing server...');
    server.close(() => {
        logger.info('HTTP server closed');
    });
    await pools.ar_management.end();
    await pools.hosxp.end();
    process.exit(0);
});