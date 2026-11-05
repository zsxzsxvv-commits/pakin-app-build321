import SwiftUI

public struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var licenseManager: HTVLicenseManager
    @EnvironmentObject var appState: AppState
    
    // Stealth Passcode State
    @State private var configHours: Int = ClockTriggerConfig.triggerHours
    @State private var configMinutes: Int = ClockTriggerConfig.triggerMinutes
    @State private var configSeconds: Int = ClockTriggerConfig.triggerSeconds
    @State private var showSaveSuccess: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.04, blue: 0.06).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("การตั้งค่า • SETTINGS")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Section 1: Stealth Camouflage Passcode Configuration
                        stealthPasscodeSection
                        
                        // Section 2: Language
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ภาษา / LANGUAGE")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            
                            HStack(spacing: 10) {
                                languageButton("ภาษาไทย (TH)", isSelected: appState.selectedLanguage == .thai) {
                                    appState.setLanguage(.thai)
                                }
                                languageButton("Tiếng Việt (VN)", isSelected: appState.selectedLanguage == .vietnamese) {
                                    appState.setLanguage(.vietnamese)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(red: 0.08, green: 0.07, blue: 0.10))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        // Section 3: Device & Security
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ข้อมูลอุปกรณ์ & สิทธิ์")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            
                            infoRow("รหัสเครื่อง (Model):", DeviceUtility.modelIdentifier)
                            infoRow("ระบบปฏิบัติการ:", "iOS \(DeviceUtility.systemVersion)")
                            infoRow("สถานะ License:", "ผูกกับเครื่องนี้แล้ว (1 Device)")
                        }
                        .padding(16)
                        .background(Color(red: 0.08, green: 0.07, blue: 0.10))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        // Section 4: Logout
                        Button(action: {
                            licenseManager.signOutLicense()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("ออกจากระบบและล้างคีย์")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.20, green: 0.05, blue: 0.08))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            configHours = ClockTriggerConfig.triggerHours
            configMinutes = ClockTriggerConfig.triggerMinutes
            configSeconds = ClockTriggerConfig.triggerSeconds
        }
    }
    
    // MARK: - Stealth Passcode Section
    private var stealthPasscodeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.orange)
                Text("รหัสลับพรางตัว (STEALTH PASSCODE)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.orange)
                Spacer()
                Text(passcodeSummary)
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(6)
            }
            
            Text("ตั้งเวลาในหน้านับถอยหลัง (Timer) เพื่อปลดล็อคเข้าสู่แอปหลักเมื่อกดเริ่มที่เวลานี้ (ค่าเริ่มต้นล็อกไว้ที่ 00:00:31)")
                .font(.system(size: 11))
                .foregroundColor(Color(white: 0.65))
                .lineSpacing(2)
            
            // Steppers for Hours, Minutes, Seconds
            VStack(spacing: 8) {
                stepperRow(label: "ชั่วโมง (ชม.):", value: $configHours, range: 0...23)
                stepperRow(label: "นาที (นาที):", value: $configMinutes, range: 0...59)
                stepperRow(label: "วินาที (วิ):", value: $configSeconds, range: 0...59)
            }
            .padding(10)
            .background(Color(white: 0.05))
            .cornerRadius(10)
            
            // Action Buttons
            HStack(spacing: 8) {
                // Save Button
                Button(action: savePasscode) {
                    HStack(spacing: 4) {
                        Image(systemName: showSaveSuccess ? "checkmark" : "square.and.arrow.down")
                        Text(showSaveSuccess ? "บันทึกแล้ว!" : "บันทึกรหัสใหม่")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(showSaveSuccess ? Color.green : Color.orange)
                    .cornerRadius(8)
                }
                
                // Reset Button
                Button(action: resetPasscode) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("รีเซ็ต (31 วิ)")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(white: 0.16))
                    .cornerRadius(8)
                }
            }
            
            // Lock to Clock Immediately
            Button(action: lockToClockNow) {
                HStack(spacing: 6) {
                    Image(systemName: "clock.badge.checkmark")
                    Text("พรางตัวกลับสู่หน้านาฬิกาทันที (Lock to Clock)")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(Color.orange.opacity(0.12))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange.opacity(0.3), lineWidth: 1))
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.07, blue: 0.10))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.2), lineWidth: 1))
    }
    
    private var passcodeSummary: String {
        return String(format: "%02d:%02d:%02d", configHours, configMinutes, configSeconds)
    }
    
    private func stepperRow(label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color(white: 0.8))
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: {
                    if value.wrappedValue > range.lowerBound {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(value.wrappedValue > range.lowerBound ? .orange : .gray)
                }
                
                Text("\(value.wrappedValue)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(minWidth: 32)
                
                Button(action: {
                    if value.wrappedValue < range.upperBound {
                        value.wrappedValue += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(value.wrappedValue < range.upperBound ? .orange : .gray)
                }
            }
        }
    }
    
    private func savePasscode() {
        ClockTriggerConfig.triggerHours = configHours
        ClockTriggerConfig.triggerMinutes = configMinutes
        ClockTriggerConfig.triggerSeconds = configSeconds
        withAnimation {
            showSaveSuccess = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSaveSuccess = false
            }
        }
    }
    
    private func resetPasscode() {
        ClockTriggerConfig.resetToDefault()
        configHours = ClockTriggerConfig.triggerHours
        configMinutes = ClockTriggerConfig.triggerMinutes
        configSeconds = ClockTriggerConfig.triggerSeconds
    }
    
    private func lockToClockNow() {
        presentationMode.wrappedValue.dismiss()
        NotificationCenter.default.post(name: NSNotification.Name("LockStealthClock"), object: nil)
    }
    
    private func languageButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color(red: 0.95, green: 0.15, blue: 0.25) : Color(white: 0.12))
                .cornerRadius(10)
        }
    }
    
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}
