// ecosystem.config.js - รัน 2 processes พร้อมกัน
module.exports = {
  apps: [
    // ✅ App 1: API Gateway Server
    {
      name: 'ar-api-gateway',
      script: './server.js',
      instances: 2,
      exec_mode: 'cluster',
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3001,
        NODE_OPTIONS: '--max-old-space-size=1024'
      },
      error_file: './logs/api-error.log',
      out_file: './logs/api-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      kill_timeout: 5000,
      listen_timeout: 10000
    },
    
    // ✅ App 2: Local Gateway Client (WebSocket)
    {
      name: 'local-gateway-client',
      script: './local-gateway-client.js',
      instances: 1,  // WebSocket client ควรรันแค่ 1 instance
      exec_mode: 'fork',  // ใช้ fork mode ไม่ใช่ cluster
      watch: false,
      max_memory_restart: '512M',
      env: {
        NODE_ENV: 'production'
      },
      error_file: './logs/client-error.log',
      out_file: './logs/client-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      autorestart: true,
      max_restarts: 10,
      min_uptime: '10s',
      restart_delay: 4000,
      kill_timeout: 5000
    }
  ]
};
