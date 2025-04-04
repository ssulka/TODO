import SwiftUI
import SwiftData
import UserNotifications

class AppearanceSettings: ObservableObject {
    @AppStorage("colorScheme") var colorScheme = 0 // 0: system, 1: light, 2: dark
    
    func getPreferredColorScheme() -> ColorScheme? {
        switch colorScheme {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return nil // System setting
        }
    }
}

@main
struct TODOApp: App {
    @State private var showSplash = true
    @StateObject private var appearanceSettings = AppearanceSettings()
    private let notificationDelegate = NotificationDelegate()

    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(appearanceSettings)
                    .preferredColorScheme(appearanceSettings.getPreferredColorScheme())
            }
        }
        .modelContainer(for: TodoTask.self)
    }

    // Funkcia na požiadanie o povolenie notifikácií
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Chyba pri žiadosti o notifikácie: \(error)")
            } else {
                print(granted ? "✅ Povolenie udelené" : "❌ Povolenie zamietnuté")
            }
        }
    }
}

// Delegát, ktorý spravuje notifikácie
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Tento metóda sa volá, keď je notifikácia pred zobrazením
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Tento metóda sa volá, keď používateľ reaguje na notifikáciu
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Tu môžeš pridať kód na spracovanie odpovede používateľa (napríklad otvorenie aplikácie alebo špecifickej obrazovky)
        print("Notifikácia bola otvorená.")
        completionHandler()
    }
}
