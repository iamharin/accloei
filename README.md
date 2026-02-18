

คู่มือการติดตั้ง
AR API Gateway
สำหรับ Client / Endpoint
รองรับการติดตั้งด้วย PM2 และ Docker
เวอร์ชัน	1.0.0
Port	3001
Node.js	v18+

 
1. ภาพรวมระบบ
AR API Gateway เป็น Local API Gateway ที่ทำหน้าที่เป็น middleware ระหว่าง Client Application กับฐานข้อมูล MySQL
โดยรองรับการเชื่อมต่อ 2 ฐานข้อมูลหลัก ได้แก่
ar_management และ HosXP
พร้อมระบบ Authentication ด้วย API Key

1.1 คุณสมบัติหลัก
•	Express.js framework พร้อม Helmet Security และ CORS
•	Rate Limiting: 10,000 requests ต่อ 15 นาที
•	Connection Pooling: 50 connections ต่อฐานข้อมูล
•	Request Timeout: 60 วินาที
•	Auto-restart ด้วย PM2 Cluster Mode (2 instances)
•	Health Check endpoint: GET /health
•	Log ด้วย Winston ไปยัง ./logs/

1.2 Port และ Endpoint
Endpoint	Method	คำอธิบาย
/health	GET	ตรวจสอบสถานะ API Gateway
/api/patients	GET	ดึงข้อมูลผู้ป่วย
/api/ar-data	GET	ดึงข้อมูล AR
/api/sync	POST	Sync ข้อมูล

 
2. สิ่งที่ต้องเตรียมก่อนติดตั้ง
2.1 ความต้องการของระบบ
ซอฟต์แวร์	เวอร์ชันขั้นต่ำ	หมายเหตุ
Node.js	v18.0+	Required (PM2 mode)
npm	v8.0+	มาพร้อม Node.js
PM2	v5.0+	เฉพาะ PM2 mode
Docker	v20.0+	เฉพาะ Docker mode
Docker Compose	v2.0+	เฉพาะ Docker mode

2.2 การเข้าถึงฐานข้อมูล
ก่อนติดตั้ง ต้องเตรียมข้อมูลการเชื่อมต่อฐานข้อมูลดังนี้
•	ar_management Database: Host IP, Username, Password, Database name(insert,update,delete )
•	HosXP Database: Host IP, Username, Password, Database name(SELECT only)
•	ตรวจสอบว่า Server สามารถเชื่อมต่อ MySQL ได้บน Port 3306

2.3 ไฟล์ที่จำเป็น
โครงสร้างไฟล์โปรเจกต์ที่ต้องมี:
ar-api-gateway/
├── server.js
├── package.json
├── package-lock.json
├── ecosystem.config.js   (สำหรับ PM2)
├── Dockerfile            (สำหรับ Docker)
├── docker-compose.yml    (สำหรับ Docker)
├── .env                  (ต้องสร้างเอง)
└── logs/                 (จะสร้างอัตโนมัติ)

 
3. การตั้งค่าไฟล์ .env
ทั้งการติดตั้งแบบ PM2 และ Docker ต้องมีไฟล์ .env อยู่ในโฟลเดอร์โปรเจกต์ สร้างไฟล์ชื่อ .env โดยมีเนื้อหาดังนี้:

# ===== Server Configuration =====
NODE_ENV=production
PORT=3001

# ===== AR Management Database =====
DB_HOST=xxx.xxx.xxx.xxx
DB_USER=username
DB_PASS=your_password
DB_NAME=ar_management

# ===== HosXP Database(select only) =====
HOSXP_HOST=xxx.xxx.xxx.xxx
HOSXP_USER=your_user
HOSXP_PASS=your_password
HOSXP_NAME=hos

# ===== Security =====
API_KEY=your_secret_api_key
SITE_ID=your_site_id
HCODE=your_hcode
ALLOWED_ORIGINS=http://server, http://localhost:3000

ทางเลือก ที่ 1 
4. การติดตั้งด้วย PM2
PM2 เหมาะสำหรับการรันบน Server โดยตรง (Bare Metal / VM) โดยไม่ต้องใช้ Container PM2 จะดูแล Process ให้รันต่อเนื่องและ restart อัตโนมัติ

4.1 ติดตั้ง Node.js และ PM2
สำหรับ Ubuntu/Debian:
# ติดตั้ง Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# ตรวจสอบเวอร์ชัน
node --version    # ควรแสดง v18.x.x
npm --version     # ควรแสดง v8.x.x หรือสูงกว่า

# ติดตั้ง PM2 แบบ Global
npm install -g pm2
pm2 --version     # ตรวจสอบเวอร์ชัน PM2

สำหรับ Windows (PowerShell as Administrator):
# ดาวน์โหลด Node.js 18 จาก https://nodejs.org
# หรือใช้ nvm-windows
nvm install 18
nvm use 18
npm install -g pm2

4.2 คัดลอกไฟล์โปรเจกต์
# คัดลอกโฟลเดอร์โปรเจกต์ไปยัง Server
scp -r ar-api-gateway/ user@server:/opt/ar-api-gateway

# หรือ Clone จาก Repository
git clone <repo-url> /opt/ar-api-gateway

4.3 ติดตั้ง Dependencies
# เข้าโฟลเดอร์โปรเจกต์
cd /opt/ar-api-gateway

# ติดตั้ง packages (production เท่านั้น)
npm ci --only=production

# สร้างโฟลเดอร์ logs
mkdir -p logs

4.4 สร้างและตั้งค่าไฟล์ .env
# สร้างไฟล์ .env
nano /opt/ar-api-gateway/.env

# วางเนื้อหาตาม Section 3 แล้วแก้ค่าให้ตรงกับ Environment

4.5 รัน API Gateway ด้วย PM2
# Start PM2 ด้วย ecosystem config
pm2 start ecosystem.config.js

# ดู Status
pm2 status

# ดู Logs แบบ Real-time
pm2 logs ar-api-gateway

# ตั้งค่า Auto-start เมื่อ Server reboot
pm2 startup
# (ทำตามคำสั่งที่แสดงขึ้นมา)
pm2 save

4.6 คำสั่ง PM2 ที่ใช้บ่อย
คำสั่ง	การทำงาน
pm2 start ecosystem.config.js	เริ่มต้น API Gateway
pm2 stop ar-api-gateway	หยุด API Gateway
pm2 restart ar-api-gateway	Restart API Gateway
pm2 reload ar-api-gateway	Reload แบบ Zero-downtime
pm2 delete ar-api-gateway	ลบออกจาก PM2
pm2 status	ดูสถานะทุก Process
pm2 logs ar-api-gateway	ดู Logs แบบ Real-time
pm2 logs ar-api-gateway --lines 100	ดู 100 บรรทัดล่าสุด
pm2 monit	Monitor แบบ Interactive

4.7 ตรวจสอบการติดตั้ง (PM2)
# ทดสอบ Health Check
curl http://localhost:3001/health

# ผลลัพธ์ที่คาดหวัง:
{ "status": "ok", "timestamp": "..." }

ทางเลือกที่ 2 
5. การติดตั้งด้วย Docker
Docker เหมาะสำหรับการ Deploy แบบ Containerized ซึ่งช่วยให้ Environment เหมือนกันทุก Server และง่ายต่อการ Scale โดย docker-compose.yml รวม API Gateway และ MySQL ไว้ด้วยกัน

5.1 ติดตั้ง Docker
สำหรับ Ubuntu/Debian:
# ติดตั้ง Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# ติดตั้ง Docker Compose
sudo apt-get install -y docker-compose-plugin

# ตรวจสอบเวอร์ชัน
docker --version
docker compose version

5.2 คัดลอกไฟล์โปรเจกต์
# คัดลอกหรือ Clone โปรเจกต์
scp -r ar-api-gateway/ user@server:/opt/ar-api-gateway
# หรือ
git clone <repo-url> /opt/ar-api-gateway

cd /opt/ar-api-gateway

5.3 สร้างและตั้งค่าไฟล์ .env
nano /opt/ar-api-gateway/.env
# วางเนื้อหาตาม Section 3 แล้วแก้ค่าให้ตรงกับ Environment

⚠ หมายเหตุ: ในโหมด Docker หาก MySQL อยู่ใน Container เดียวกัน ให้ใช้ชื่อ service เช่น DB_HOST=mysql แทน IP Address

5.4 Build และ Start Container
กรณีต้องการรันทั้ง API Gateway + MySQL ใน Docker:
# Build image และ Start
docker compose up -d --build

# ดู Status
docker compose ps

กรณีต้องการรันเฉพาะ API Gateway (ใช้ MySQL ภายนอก):
# Build image เท่านั้น
docker build -t ar-api-gateway .

# Run container
docker run -d \
  --name ar-api-gateway \
  -p 3001:3001 \
  --env-file .env \
  --restart unless-stopped \
  -v $(pwd)/logs:/app/logs \
  ar-api-gateway

5.5 คำสั่ง Docker ที่ใช้บ่อย
คำสั่ง	การทำงาน
docker compose up -d --build	Build และ Start ทุก service
docker compose down	หยุดและลบ Container
docker compose restart	Restart ทุก service
docker compose logs -f api-gateway	ดู Logs แบบ Real-time
docker compose logs --tail=100	ดู 100 บรรทัดล่าสุด
docker compose ps	ดูสถานะ Container
docker compose pull	ดึง image ใหม่
docker exec -it ar-api-gateway sh	เข้าถึง Shell ใน Container
docker stats ar-api-gateway	Monitor CPU/RAM แบบ Real-time

5.6 ตรวจสอบการติดตั้ง (Docker)
# ทดสอบ Health Check
curl http://localhost:3001/health

# ดู Health Status จาก Docker
docker inspect --format='{{.State.Health.Status}}' ar-api-gateway

# ผลลัพธ์ที่คาดหวัง: healthy

 
6. เปรียบเทียบ PM2 vs Docker
หัวข้อ	PM2	Docker
การติดตั้ง	Node.js + PM2 บน Host	Docker Engine เท่านั้น
Isolation	ใช้ Node.js บน Host โดยตรง	Isolated Container
Resource Usage	เบากว่า	มี Overhead เล็กน้อย
Environment	ต้องจัดการ Dependency เอง	Consistent ทุก Server
Auto-restart	✓ PM2 จัดการ	✓ Docker restart policy
Scale	Cluster Mode (หลาย CPU)	Scale ด้วย Compose
Log Management	ไฟล์ใน ./logs/	ไฟล์ใน ./logs/ (volume mount)
Update	git pull + pm2 restart	docker compose up -d --build
แนะนำสำหรับ	VPS / Dedicated Server	Server ที่ใช้ Docker อยู่แล้ว

 
7. การแก้ไขปัญหาที่พบบ่อย
7.1 ไม่สามารถเชื่อมต่อฐานข้อมูล
อาการ: ECONNREFUSED หรือ Access denied
•	ตรวจสอบ DB_HOST ใน .env ว่าถูกต้อง
•	ตรวจสอบ Username/Password ของฐานข้อมูล
•	ตรวจสอบว่า MySQL รับ connection จาก IP ของ Server
•	ทดสอบด้วย: mysql -h <DB_HOST> -u <DB_USER> -p

7.2 Port 3001 ถูกใช้งานอยู่แล้ว
# ตรวจสอบ process ที่ใช้ Port 3001
lsof -i :3001
# หรือ
netstat -tulpn | grep 3001

# แก้ไขโดยเปลี่ยน PORT ใน .env
PORT=3002

7.3 PM2 restart loop
อาการ: PM2 Status แสดง errored หรือ restart ซ้ำ
# ดู Error log
pm2 logs ar-api-gateway --err

# หรือดูไฟล์ log โดยตรง
cat logs/pm2-error.log

7.4 Docker Container ไม่ Start
# ดู Logs ของ Container
docker compose logs api-gateway

# ดู Container events
docker events --filter container=ar-api-gateway

7.5 ตรวจสอบ Firewall
# Ubuntu - เปิด Port 3001
sudo ufw allow 3001/tcp

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=3001/tcp
sudo firewall-cmd --reload

 
8. การอัปเดตระบบ
8.1 อัปเดตด้วย PM2
cd /opt/ar-api-gateway

# ดึงโค้ดใหม่
git pull origin main

# ติดตั้ง dependencies ใหม่ถ้ามีการเปลี่ยนแปลง
npm ci --only=production

# Reload แบบ Zero-downtime
pm2 reload ar-api-gateway

8.2 อัปเดตด้วย Docker
cd /opt/ar-api-gateway

# ดึงโค้ดใหม่
git pull origin main

# Build image ใหม่และ Restart
docker compose up -d --build

# ลบ image เก่าที่ไม่ใช้
docker image prune -f

9. แนวทางความปลอดภัย
•	ตั้งค่า ALLOWED_ORIGINS ให้ระบุเฉพาะ IP ของ Client ที่ต้องการ
•	ใช้ API_KEY ที่มีความยาวเพียงพอและเดาได้ยาก
•	ไม่เปิด Port 3001 สู่ Public Internet โดยไม่จำเป็น
•	เพิ่ม IP ของ Server ที่เชื่อถือได้ใน trustedIPs ใน server.js เพื่อ Bypass rate limit
•	ตรวจสอบ Logs เป็นประจำที่ ./logs/
•	ตั้งค่า Firewall ให้อนุญาตเฉพาะ IP ที่จำเป็น


AR API Gateway Installation Guide | Version 1.0.0 | ar_management System
