<div align="center">

# <img src="http://209.15.111.58/images/favicon.png"> <br>AR API Gateway

**Local API Gateway สำหรับระบบบริหารจัดการบัญชีลูกหนี้ (AR Management)**

[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Express](https://img.shields.io/badge/Express-4.x-000000?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
[![PM2](https://img.shields.io/badge/PM2-Cluster-2B037A?style=for-the-badge&logo=pm2&logoColor=white)](https://pm2.keymetrics.io)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

<br/>

> ACCLOEI Gateway กลางสำหรับเชื่อมต่อ Client กับฐานข้อมูล  AR Management และ HosXP  
> รองรับ WebSocket Proxy, Rate Limiting, Authentication และ Auto-restart

<br/>

[📋 คู่มือติดตั้ง](#-การติดตั้ง) • [🔌 API Reference](#-api-endpoints) • [⚙️ Configuration](#️-configuration) • [🐛 Troubleshooting](#-troubleshooting)

</div>

---

## 📌 สารบัญ

- [ภาพรวมระบบ](#-ภาพรวมระบบ)
- [สิ่งที่ต้องเตรียม](#-สิ่งที่ต้องเตรียม)
- [การติดตั้ง](#-การติดตั้ง)
  - [แบบ PM2](#-วิธีที่-1-pm2-แนะนำสำหรับ-vps--server)
  - [แบบ Docker](#-วิธีที่-2-docker)
- [Configuration](#️-configuration)
- [API Endpoints](#-api-endpoints)
- [WebSocket Client](#-websocket-client)
- [Troubleshooting](#-troubleshooting)

---

## 🏗 ภาพรวมระบบ

```
┌─────────────────┐        WebSocket         ┌──────────────────┐
│   Proxy Server  │ ◄──────────────────────► │  Gateway Client  │
│                      │       (Port 8088)         │  (เครื่อง Client)  │
└─────────────────┘                           └────────┬─────────┘
                                                       │ HTTP
                                                       ▼
                                              ┌──────────────────┐
                                              │  AR API Gateway  │
                                              │   (Port 3001)    │
                                              └────────┬─────────┘
                                                       │
                              ┌────────────────────────┤
                              │                        │
                     ┌────────▼────────┐    ┌──────────▼───────┐
                     │  ar_management  │    │      HosXP       │
                     │    Database     │    │    Database      │
                     └─────────────────┘    └──────────────────┘
```

### ✨ คุณสมบัติหลัก

| คุณสมบัติ | รายละเอียด |
|-----------|-----------|
| 🔐 Authentication | API Key + Site ID validation |
| 🚦 Rate Limiting | 10,000 req / 15 นาที |
| 🔄 Auto-restart | PM2 Cluster (2 instances) |
| 🗄️ Connection Pool | 50 connections / ฐานข้อมูล |
| ⏱️ Timeout | Request timeout 60 วินาที |
| 📝 Logging | Winston → `./logs/` |
| 🏥 Health Check | `GET /health` |

---

## 📦 สิ่งที่ต้องเตรียม

| ซอฟต์แวร์ | เวอร์ชัน | PM2 | Docker |
|-----------|---------|-----|--------|
| Node.js | v18+ | ✅ | ❌ (อยู่ใน image) |
| npm | v8+ | ✅ | ❌ |
| PM2 | v5+ | ✅ | ❌ |
| Docker | v20+ | ❌ | ✅ |
| Docker Compose | v2+ | ❌ | ✅ |

---

## 🚀 การติดตั้ง

### 1. Clone Repository

```bash
git clone https://github.com/iamharin/accloei.git
cd accloei/ar-api-gateway/
```

### 2. ตั้งค่าไฟล์ `.env`

```bash
cp .env.example .env
nano .env
```

> ดูรายละเอียดตัวแปรทั้งหมดได้ที่ [Configuration](#️-configuration)

---

### 🟢 วิธีที่ 1: PM2 (แนะนำสำหรับ VPS / Server)

```bash
# ติดตั้ง Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# ติดตั้ง PM2
npm install -g pm2

# ติดตั้ง dependencies
npm ci --only=production

# Start
pm2 start ecosystem.config.js

# ตั้งค่า Auto-start เมื่อ reboot
pm2 startup && pm2 save
```

**คำสั่ง PM2 ที่ใช้บ่อย:**

```bash
pm2 status                        # ดูสถานะ
pm2 logs ar-api-gateway           # ดู logs real-time
pm2 restart ar-api-gateway        # restart
pm2 reload ar-api-gateway         # reload (zero-downtime)
pm2 monit                         # monitor แบบ interactive
```

---

### 🐳 วิธีที่ 2: Docker

```bash
# Start ทั้งหมด (API Gateway + MySQL)
docker compose up -d --build

# ดูสถานะ
docker compose ps

# ดู logs
docker compose logs -f api-gateway
```

**กรณีใช้ MySQL ภายนอก (ไม่ต้องการ MySQL container):**

```bash
docker build -t ar-api-gateway .

docker run -d \
  --name ar-api-gateway \
  -p 3001:3001 \
  --env-file .env \
  --restart unless-stopped \
  -v $(pwd)/logs:/app/logs \
  ar-api-gateway
```

---

### ✅ ทดสอบการติดตั้ง

```bash
curl http://localhost:3001/health
```

**ผลลัพธ์ที่คาดหวัง:**
```json
{ "status": "ok", "timestamp": "2025-01-01T00:00:00.000Z" }
```
### ✅ เข้าใช้งาน Accloei

```bash
http://209.15.111.58/
```
---

## ⚙️ Configuration

สร้างไฟล์ `.env` จาก `.env.example` แล้วแก้ค่าให้ตรงกับ environment:

```env
# Server Configuration
NODE_ENV=production
PORT=3001
LOG_LEVEL=info

# API Security
API_KEY=ได้จาก super admin
SITE_ID=ได้จาก super admin
HCODE=XXXXX //รหัส รพ. 5 หลัก


PROXY_SERVER=ws://209.15.111.58:8088
LOCAL_API_URL=http://localhost:3001/api

# Allowed Origins (comma-separated)
ALLOWED_ORIGINS=http://209.15.111.58,http://localhost:3000

# AR Management Database
DB_HOST=xxx.xxx.xxx.xxx
DB_USER=username
DB_PASS=password
DB_NAME=ar_management
DB_PORT=3306

# HOSxP Database(select only)
HOSXP_HOST=xxx.xxx.xxx.xxx
HOSXP_USER=xxxxx
HOSXP_PASS=xxxxx
HOSXP_NAME=hos
HOSXP_PORT=3306

# JWT Configuration (for future use)
JWT_SECRET=your-jwt-secret-here
JWT_EXPIRES_IN=24h
```

> ⚠️ **อย่า Commit ไฟล์ `.env` ขึ้น Git** เด็ดขาด เพราะมีข้อมูล Password และ API Key

---

## 🔌 API Endpoints

Headers ที่ต้องส่งทุก Request:

```
X-API-Key: <your_api_key>
X-Site-ID: <your_site_id>
Content-Type: application/json
```

### Health

| Method | Endpoint | คำอธิบาย |
|--------|----------|---------|
| `GET` | `/health` | ตรวจสอบสถานะ Gateway |

### Authentication

| Method | Endpoint | คำอธิบาย |
|--------|----------|---------|
| `POST` | `/api/auth/login` | เข้าสู่ระบบ |
| `POST` | `/api/auth/logout` | ออกจากระบบ |

### AR Management

| Method | Endpoint | คำอธิบาย |
|--------|----------|---------|
| `GET` | `/api/ar` | ดึงรายการ AR ทั้งหมด |
| `GET` | `/api/ar/:id` | ดึงข้อมูล AR รายการเดียว |

### HosXP

| Method | Endpoint | คำอธิบาย |
|--------|----------|---------|
| `GET` | `/api/hosxp/patient/:hn` | ดึงข้อมูลผู้ป่วยตาม HN |
| `POST` | `/api/hosxp/import-ar` | นำเข้าข้อมูล AR จาก HosXP |

### Utility

| Method | Endpoint | คำอธิบาย |
|--------|----------|---------|
| `POST` | `/api/query` | รัน Custom Query |

---

## 🔗 WebSocket Client

`local-gateway-client.js` ทำหน้าที่เชื่อมต่อกับ Proxy Server แล้วรับ-ส่ง Request มายัง API Gateway

```bash
# รันด้วย Node.js โดยตรง
node local-gateway-client.js

# หรือรันผ่าน PM2
pm2 start local-gateway-client.js --name gateway-client
```

**Flow การทำงาน:**
```
Proxy Server → WebSocket → Gateway Client → HTTP → AR API Gateway → MySQL
```

**ค่าที่ต้องตั้งใน `.env`:**
```env
SITE_ID=your_site_id
API_KEY=your_api_key
PROXY_SERVER=ws://ip-server:8088
```

---

## 📄 โครงสร้างโปรเจกต์

```
accloei/
├── 📄 server.js                        # API Gateway หลัก
├── 📄 local-gateway-client.js          # WebSocket Client
├── 📄 ecosystem.config.js              # PM2 configuration
├── 🐳 Dockerfile                       # Docker image
├── 🐳 docker-compose.yml               # Docker Compose (Gateway + MySQL)
├── 📄 package.json
├── 📄 .env.example                     # Template .env
├── 📁 logs/                            # Log files (auto-created)
│   ├── pm2-error.log
│   ├── pm2-out.log
│   ├── error.log
│   └── combined.log
└── 📚 docs/
    └── AR-API-Gateway-Installation-Guide.docx
```

---

## 🐛 Troubleshooting

<details>
<summary><b>❌ ไม่สามารถเชื่อมต่อฐานข้อมูล (ECONNREFUSED)</b></summary>

```bash
# ทดสอบเชื่อมต่อ MySQL โดยตรง
mysql -h <DB_HOST> -u <DB_USER> -p

# ตรวจสอบ .env ว่า DB_HOST, DB_USER, DB_PASS ถูกต้อง
cat .env | grep DB_
```
</details>

<details>
<summary><b>❌ Port 3001 ถูกใช้งานอยู่แล้ว</b></summary>

```bash
# หา process ที่ใช้ port
lsof -i :3001

# เปลี่ยน port ใน .env
PORT=3002
```
</details>

<details>
<summary><b>❌ PM2 restart loop</b></summary>

```bash
# ดู error log
pm2 logs ar-api-gateway --err
cat logs/pm2-error.log
```
</details>

<details>
<summary><b>❌ Docker container ไม่ start</b></summary>

```bash
# ดู logs
docker compose logs api-gateway

# ตรวจสอบ health
docker inspect --format='{{.State.Health.Status}}' ar-api-gateway
```
</details>

<details>
<summary><b>❌ WebSocket disconnect บ่อย</b></summary>

Client มี exponential backoff อยู่แล้ว จะ reconnect อัตโนมัติ ตรวจสอบ log:
```bash
pm2 logs gateway-client
```
</details>

---

## 📚 เอกสารเพิ่มเติม

| เอกสาร | ลิงก์ |
|--------|-------|
| 📋 คู่มือติดตั้งฉบับเต็ม | [docs/AR-API-Gateway-Installation-Guide.docx](docs/AR-API-Gateway-Installation-Guide.docx) |

---

## 🔄 การอัปเดต

```bash
# PM2
git pull origin main
npm ci --only=production
pm2 reload ar-api-gateway

# Docker
git pull origin main
docker compose up -d --build
docker image prune -f
```

---

<div align="center">

**AR API Gateway** • MIT License • [iamharin](https://github.com/iamharin)

</div>
