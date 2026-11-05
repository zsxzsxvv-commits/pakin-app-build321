# MASTER SPECIFICATION & AI PROMPT GUIDE: PAKIN HEX v2.0
## ULTIMATE iOS CONTROL CENTER & ENTERPRISE BACKEND ECOSYSTEM

เอกสารฉบับนี้จัดทำขึ้นเพื่อให้ทั้งทีมวิศวกรซอฟต์แวร์ และโมเดลปัญญาประดิษฐ์ (ChatGPT, Claude, Gemini) เข้าใจสถาปัตยกรรม, โครงสร้างโค้ด, API ทุกรูปแบบ, กลไกความปลอดภัย, และการทำงานทั้งหมดของระบบ **PAKIN HEX v2.0** อย่างสมบูรณ์ 100%

---

## 1. ข้อมูลสรุปของแอปพลิเคชัน (SYSTEM ARCHITECTURE)

### 1.1 วัตถุประสงค์และการทำงานหลัก
PAKIN HEX v2.0 คือระบบควบคุมและติดตั้งแพตช์เกมบนระบบปฏิบัติการ iOS ควบคู่กับ Backend API และ WebAdmin โดยมีจุดเด่นคือ:
1. **ระบบพรางตัวด้วยหน้าจอนาฬิกา (iOS Clock Camouflage)**: 
   - เมื่อเปิดแอปพลิเคชัน ตัวแอปจะแสดงผลเป็นแอป "นาฬิกา (Clock)" ดั้งเดิมของ Apple มีครบทั้ง 4 แท็บจริง: **นาฬิกาโลก (World Clock)**, **การปลุก (Alarm)**, **นาฬิกาจับเวลา (Stopwatch)**, และ **นับถอยหลัง (Timer)**
   - ผู้ใช้งานทั่วไปจะไม่สามารถเข้าถึงระบบภายในได้ จนกว่าจะตั้งเวลานับถอยหลังเป็น **`00:00:31` (0 ชั่วโมง 0 นาที 31 วินาที)** แล้วกดปุ่ม "เริ่ม" ตัวแอปจึงจะปลดล็อกเข้าสู่หน้า **VIP License Gate**
2. **ระบบรักษาความปลอดภัย VIP License & Hardware Lock (1 Key : 1 Device)**:
   - คีย์ VIP แต่ละคีย์มีฟอร์แมต `HEX-XXXX-XXXX`
   - เมื่อนำไปเปิดใช้งานครั้งแรก ระบบจะดึงรหัส Hardware Identification (HWID / IdentifierForVendor) และผูกสิทธิ์เข้ากับเครื่องนั้นทันที
   - หากนำคีย์ไปกรอกในเครื่องอื่น ระบบจะปฏิเสธด้วยรหัสข้อผิดพลาด `DEVICE_MISMATCH`
   - แอดมินสามารถปลดล็อกเครื่อง (Reset HWID) ได้จากหลังบ้าน
3. **ระบบจัดการแพตช์ 3105 และถอดรหัสอัตโนมัติ (Zero-Leak Security)**:
   - รองรับไฟล์ 3105 ในหมวด **AIM** จำนวน 2 ไฟล์หลัก:
     1. `ขยายดาเมจตัว.3105` (ขนาด 64,584 bytes)
     2. `ยิงตัวขึ้นหัว.3105` (ขนาด 64,581 bytes)
   - รหัสผ่านถอดรหัสและติดตั้งคือ: **`@imnot_vt`**
   - **ข้อกำหนดความปลอดภัยของ UI:** ห้ามแสดงรหัสผ่าน, ห้ามแสดงขนาดไบต์, และห้ามบอกรายละเอียดเชิงลึกบนหน้าจอ โดยระบบจะใส่รหัส `@imnot_vt` ในเบื้องหลังอัตโนมัติเมื่อกด "ติดตั้ง (1-Tap)"
   - **ปุ่ม "คืนค่าเดิม" (Revert to Original):** มีระบบสำรองไฟล์เดิมอัตโนมัติ ทำให้ผู้ใช้สามารถกดคืนค่าเกมกลับเป็นสภาพปกติได้ทุกเวลา
4. **ระบบ Anti-Ban DNS Profile (.mobileconfig)**:
   - ให้บริการดาวน์โหลดและติดตั้ง Apple Configuration Profile (`.mobileconfig`) ซึ่งกำหนดค่า DoH (DNS over HTTPS) ของ Cloudflare 1.1.1.1 บล็อกเซิร์ฟเวอร์วิเคราะห์และตรวจสอบไฟล์ของเกม 100%

---

## 2. API ENDPOINTS REFERENCE (ทุกรูปแบบของระบบหลังบ้าน)

เซิร์ฟเวอร์ Backend รันบน Node.js Port 3000 (Pure Built-in Zero Dependencies)

### 2.1 ตรวจสอบสถานะการเชื่อมต่อ (Ping & Health Check)
- **Endpoint:** `GET /api/v2/ping` หรือ `GET /health`
- **Response:**
```json
{
  "success": true,
  "status": "PONG",
  "connected": true,
  "service": "PAKIN_HEX_API",
  "version": "2.0.0",
  "timestamp": 1730825000000
}
```

### 2.2 ตรวจสอบและผูกสิทธิ์คีย์ VIP (Verify License & Bind Device)
- **Endpoint:** `POST /api/v2/license/verify`
- **Headers:** `Content-Type: application/json`
- **Request Body:**
```json
{
  "licenseKey": "HEX-VIP-9999-ACTIVE",
  "deviceId": "4F92A-88D1B-2200E-PAKIN",
  "deviceModel": "iPhone 16 Pro",
  "osVersion": "18.1"
}
```
- **Response (สำเร็จ):**
```json
{
  "success": true,
  "status": "AUTHORIZED",
  "message": "ใบอนุญาตถูกต้องและผูกสิทธิ์กับอุปกรณ์เรียบร้อย",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresAt": "2026-12-05T00:00:00.000Z",
  "isLifetime": false
}
```
- **Response (ผิดเครื่อง - DEVICE_MISMATCH):**
```json
{
  "success": false,
  "status": "DEVICE_MISMATCH",
  "error": "คีย์นี้ถูกผูกไว้กับอุปกรณ์อื่นแล้ว กรุณาติดต่อแอดมินเพื่อรีเซ็ต HWID"
}
```
- **Response (หมดอายุ - EXPIRED):**
```json
{
  "success": false,
  "status": "EXPIRED",
  "error": "คีย์นี้หมดอายุการใช้งานแล้ว"
}
```

### 2.3 สร้างคีย์ VIP ใหม่ (Admin License Creator)
- **Endpoint:** `POST /api/v2/license/create`
- **Headers:** `Content-Type: application/json`, `X-Admin-Token: PAKIN_ADMIN_SECRET`
- **Request Body:**
```json
{
  "username": "customer_01",
  "durationDays": 30,
  "isLifetime": false,
  "maxDevices": 1,
  "note": "ลูกค้า VIP สั่งซื้อ Free Fire AIM"
}
```
- **Response:**
```json
{
  "success": true,
  "licenseKey": "HEX-819A-9012",
  "username": "customer_01",
  "expiresAt": "2026-12-05T12:00:00.000Z",
  "createdAt": "2026-11-05T12:00:00.000Z"
}
```

### 2.4 ปลดล็อกเครื่อง (HWID Reset)
- **Endpoint:** `POST /api/v2/license/reset-hwid`
- **Request Body:**
```json
{
  "licenseKey": "HEX-819A-9012"
}
```
- **Response:**
```json
{
  "success": true,
  "message": "ปลดล็อกอุปกรณ์สำหรับคีย์ HEX-819A-9012 เรียบร้อยแล้ว สามารถนำไปผูกเครื่องใหม่ได้"
}
```

### 2.5 ดึงแค็ตตาล็อกไฟล์ 3105 (Catalog Feed)
- **Endpoint:** `GET /api/v2/mods/catalog?game=normal`
- **Response:**
```json
{
  "success": true,
  "game": "com.dts.freefireth",
  "category": "AIM",
  "mods": [
    {
      "id": "mod-damage-body-01",
      "name": "ขยายดาเมจตัว.3105",
      "category": "AIM",
      "status": "active",
      "autoPassword": "@imnot_vt"
    },
    {
      "id": "mod-aim-body-head-02",
      "name": "ยิงตัวขึ้นหัว.3105",
      "category": "AIM",
      "status": "active",
      "autoPassword": "@imnot_vt"
    }
  ]
}
```

---

## 3. PROMPT สำหรับสั่งและอธิบายให้ AI (COPY & PASTE READY)

เมื่อคุณต้องการนำข้อมูลนี้ไปคุยกับ ChatGPT, Claude, หรือโมเดลอื่น ๆ สามารถคัดลอกข้อความด้านล่างนี้ส่งให้ AI ได้ทันที:

```text
คุณคือสถาปนิกและผู้เชี่ยวชาญด้าน iOS App Development (Swift/SwiftUI) และ Node.js Backend 
นี่คือข้อมูลสถาปัตยกรรมทั้งหมดของแอปพลิเคชัน "PAKIN HEX v2.0" ซึ่งเป็นระบบควบคุมและติดตั้งแพตช์ 3105 สำหรับ iOS:

[1. การทำงานของหน้าจอและการพรางตัว]
- หน้าแรกสุดคือ Native iOS Clock Camouflage ซึ่งมีฟังก์ชันนาฬิกาของจริง 4 แท็บ: นาฬิกาโลก, การปลุก, นาฬิกาจับเวลา, และนับถอยหลัง
- เงื่อนไขลับ: เมื่อผู้ใช้ตั้งเวลานับถอยหลังที่ 00:00:31 (0 ชม. 0 นาที 31 วิ) แล้วกดปุ่ม "เริ่ม" ระบบจะสลับเข้าสู่หน้า VIP License Gate ทันที

[2. ระบบ VIP License & ความปลอดภัย]
- ใช้หลักการ 1 Key : 1 Device Hardware Lock
- เมื่อตรวจสอบคีย์ผ่าน Backend API (POST /api/v2/license/verify) หากคีย์ถูกต้องจะผูกกับ HWID ของเครื่อง
- หากคีย์ถูกใช้กับเครื่องอื่น ระบบจะตอบกลับ DEVICE_MISMATCH
- แอดมินสามารถสร้างคีย์และรีเซ็ต HWID ผ่าน Backend ได้

[3. การจัดการไฟล์แพตช์ 3105]
- มี 2 ไฟล์หลักในหมวด AIM สำหรับเกม Free Fire ธรรมดา (com.dts.freefireth):
  1. "ขยายดาเมจตัว.3105"
  2. "ยิงตัวขึ้นหัว.3105"
- รหัสผ่านถอดรหัสของทั้งสองไฟล์คือ: "@imnot_vt"
- กฎของ UI: ห้ามแสดงรหัสผ่าน, ห้ามแสดงขนาดไฟล์, และห้ามแสดงรายละเอียดเชิงลึก โดยแอปจะใส่รหัสผ่านอัตโนมัติในเบื้องหลังเมื่อผู้ใช้กดปุ่ม "ติดตั้ง (1-Tap)"
- มีปุ่ม "คืนค่าเดิม" (Revert to Original) เพื่อนำไฟล์สำรองกลับมาแทนที่และรีเซ็ตเกมสู่ค่าโรงงาน

[4. ระบบ Anti-Ban DNS]
- รองรับการดาวน์โหลด Apple Configuration Profile (.mobileconfig) เพื่อตั้งค่า DoH Cloudflare 1.1.1.1 ป้องกันการส่งบันทึกการเล่นไปยังเซิร์ฟเวอร์ตรวจสอบ

[5. ดีไซน์และการแสดงผล]
- โทนสี: OLED Pure Black & White Monochrome (#050507, #121216, #FFFFFF)
- ไม่ใช้อีโมจิในส่วนสำคัญ แต่ใช้โลโก้เกมแท้และไอคอน Vector สไตล์ Apple
- โลโก้แบรนด์ของระบบ: https://i.postimg.cc/L5sNwtLr/124-20260917014758.jpg

โปรดใช้ข้อมูลด้านบนนี้เป็นฐานความรู้หลักในการพัฒนา, ให้คำปรึกษา, หรือเขียนโค้ดเพิ่มเติมสำหรับโปรเจกต์ PAKIN HEX
```

---

## 4. สรุปไฟล์ที่ถูกจัดวางในเครื่องผู้ใช้ (DELIVERY ARTIFACTS)

| ชนิดไฟล์ | ที่อยู่ไฟล์ (Path) | คำอธิบาย |
|---|---|---|
| **iOS IPA Package** | `C:\Users\Windows\Desktop\PAKIN_HEX_v2.ipa` | ไฟล์ IPA แท้พร้อมโครงสร้าง Mach-O ARM64 Stub, Info.plist และฝังไฟล์ 3105 ทั้งสองไฟล์ พร้อมสำหรับ Sideload (TrollStore, Scarlet, AltStore) |
| **Interactive HTML App** | `C:\Users\Windows\Desktop\PAKIN_HEX_APP_SIMULATOR.html` | ตัวจำลองแอปบน iPhone 16 Pro ตัวเต็ม เปิดบนเบราว์เซอร์ได้ทันที ไม่มีอีโมจิ มีนาฬิกาครบ 4 แท็บ, ปลดล็อก 00:00:31, และดาวน์โหลด DNS ได้ |
| **DNS Profile** | `C:\Users\Windows\Desktop\pakin_antiban_dns.mobileconfig` | โปรไฟล์ Apple Config แท้สำหรับติดตั้ง Encrypted DNS ลงบน iOS |
| **Swift Source Code** | `C:\Users\Windows\Desktop\PAKIN_PROJECT\UP_TO_GITHUB\` | ซอร์สโค้ดภาษา Swift ทั้งหมด (59 ไฟล์) อัปเดตรหัสผ่าน `@imnot_vt` และทั้ง 2 ไฟล์ใหม่เรียบร้อย |
| **AI Prompt & Spec** | `C:\Users\Windows\Desktop\PAKIN_HEX_API_AND_PROMPT_GUIDE.md` | เอกสารคู่มือ API และ Prompt ตัวเต็มฉบับนี้ |
