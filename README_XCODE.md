# คู่มือการเปิดและคอมไพล์โปรเจกต์ PAKIN EPIC ด้วย Xcode

## 1. ข้อมูลภาพรวมโปรเจกต์
- **ชื่อโปรเจกต์**: PAKIN EPIC (Build 19)
- **Bundle Identifier**: `com.apple.mobile.MobileHouseArrest`
- **เวอร์ชัน**: `1.1.6` (Build `19`)
- **เป้าหมาย iOS (Deployment Target)**: iOS 16.0 หรือใหม่กว่า (แนะนำทดสอบบน iOS 17.0 - 27.x)
- **ภาษาและเฟรมเวิร์ก**: Swift 5.9+, SwiftUI, Combine, MobileGestalt / HouseArrest APIs

---

## 2. โครงสร้างโฟลเดอร์ของโปรเจกต์ (Clean iOS Architecture)
```
Recovered_Source_Project/
├── App/
│   ├── PAKIN_EPICApp.swift          # Main App Lifecycle, License check & URL scheme handling
│   └── ContentView.swift            # Root TabView Navigation (Home, Patches, Files, Cleaner, Sources, Settings)
├── Core/
│   ├── Config/
│   │   └── AppConfig.swift          # ค่าคงที่, เซิร์ฟเวอร์ API Endpoints, Versioning
│   ├── Network/
│   │   └── HTVLicenseAPI.swift      # การเชื่อมต่อ License Server (POST /api/v4/license/redeem)
│   ├── Authentication/
│   │   ├── HTVLicenseManager.swift  # ตัวจัดการสิทธิ์ License, การบันทึก Session Token, Device ID
│   │   └── HTVLicenseError.swift    # นิยามข้อผิดพลาดระบบ License ภาษาไทย
│   └── Utilities/
│       ├── AppLog.swift             # ระบบบันทึก Session Activity Logs
│       └── DeviceUtility.swift      # ตัวตรวจสอบรุ่นอุปกรณ์, เวอร์ชั่น iOS, Device ID
├── Features/
│   ├── LicenseGate/
│   │   └── HTVLicenseGateView.swift # หน้าจอความปลอดภัยบังคับใส่ License Key ก่อนเข้าใช้งาน
│   ├── Home/
│   │   └── RepositoryHomeView.swift # หน้าแรกแสดงสถานะ Kernel Exploit, การ์ดเครื่องมือ, แพตช์เกม
│   ├── GestaltEditor/
│   │   └── GestaltEditorView.swift  # ตัวปรับแต่ง MobileGestalt (Action Button, AOD, Apple Intelligence ฯลฯ)
│   ├── FileBrowser/
│   │   └── AppDataBrowserView.swift # โปรแกรมสำรวจไฟล์คอนเทนเนอร์แอป (MHA-C2)
│   ├── Patches/
│   │   └── PatchProjectsView.swift  # ระบบสร้างและสลับใช้งานแพตช์เกม/แอป (.3105)
│   ├── Wallpapers/
│   │   └── WallpapersView.swift      # ระบบติดตั้งและรีเซ็ตวอลเปเปอร์ PosterBoard (.tendies)
│   ├── Cleaner/
│   │   └── CleanerView.swift        # เครื่องมือสแกนและลบ Cache ชั่วคราวของแอป
│   ├── Sources/
│   │   └── RepositorySourcesView.swift # คลังรวมแพ็กเกจออนไลน์และการเพิ่ม Repository URL
│   ├── Settings/
│   │   └── SettingsView.swift       # ข้อมูลเครื่อง, สถานะสิทธิ์ VIP, Developer Mode, Session Logs
│   └── Onboarding/
│       └── OnboardingView.swift     # หน้าแนะนำการใช้งานและเงื่อนไขใบรับรอง (Enterprise Cert)
├── Models/
│   ├── AppState.swift               # จัดการ State ภาพรวมและการรัน Exploit
│   ├── LicenseModels.swift          # โครงสร้าง JSON ของ License Request/Response
│   ├── PatchModels.swift            # โครงสร้างโปรเจกต์และกฎของแพตช์ .3105
│   ├── RepositoryModels.swift       # โครงสร้างแพ็กเกจและคลังดาวน์โหลด
│   └── WallpaperModels.swift        # โครงสร้างแพ็กเกจวอลเปเปอร์ PosterBoard
├── Components/
│   ├── HTVScreenBackground.swift    # ธีมพื้นหลัง Dark Cyberpunk Gradient
│   ├── HTVSectionHeader.swift       # Header ของแต่ละ Section
│   └── HTVComponents.swift          # Status Pill, Card Modifier, Icon Widget
├── Resources/
│   ├── Assets.xcassets/             # ไอคอนแอป AppIcon ครบตามไฟล์ IPA
│   ├── Info.plist                   # ข้อมูลสิทธิ์การเข้าถึง, URL Scheme, UTExportedTypes (.3105)
│   ├── en.lproj/Localizable.strings # ข้อความภาษาอังกฤษ
│   └── th.lproj/Localizable.strings # ข้อความภาษาไทย
└── PAKIN_EPIC.xcodeproj/
    └── project.pbxproj              # ไฟล์การตั้งค่าโปรเจกต์สำหรับ Xcode 14.0 - 16.x
```

---

## 3. ขั้นตอนการเปิดโปรเจกต์ด้วย Xcode บน macOS
1. คัดลอกโฟลเดอร์ `Recovered_Source_Project` ไปยังเครื่อง Mac
2. ดับเบิลคลิกเปิดไฟล์ `PAKIN_EPIC.xcodeproj`
3. ใน Xcode:
   - ไปที่แถบ **Signing & Capabilities**
   - ตรวจสอบ Team: เลือก Developer Account ของคุณ หรือใช้ Ad-hoc / Enterprise Signing
   - หากต้องการติดตั้งบนเครื่องจริง: ต้องใช้ใบรับรององค์กร (Enterprise Certificate) หรือใช้เครื่องมือ Sign ภายนอก (eSign / Scarlet / TrollStore) ตามสถาปัตยกรรมของแอป
4. เลือกเป้าหมายการรัน (Destination):
   - **Any iOS Device (arm64)** หรือ iPhone จริงที่เชื่อมต่ออยู่
5. กดปุ่ม **Run** (Command + R) หรือเลือก **Product > Archive** เพื่อส่งออกเป็นไฟล์ IPA ใหม่

---

## 4. รายการ API Server ที่เกี่ยวข้อง
- **License Base URL**: `https://hightapi.netlify.app`
- **Redeem Endpoint**: `POST /api/v4/license/redeem`
- **Session Endpoint**: `POST /api/v4/license/session`
- **Package Catalog**: `https://hightapi.netlify.app/api/v4/packages`
- **Default Sources**: `https://raw.githubusercontent.com/YangJiiii/3105-repo/main/sources.json`
