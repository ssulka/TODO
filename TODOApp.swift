import SwiftUI
import SwiftData
import UserNotifications
import WidgetKit

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
    static func saveTasksForWidget(tasks: [TodoTask]) {
            let sharedDefaults = UserDefaults(suiteName: "group.com.samuelsulka.todo") // group identifier

            let taskEntries = tasks
                .filter { !$0.isDone }
                .sorted { ($0.deadline ?? Date.distantFuture) < ($1.deadline ?? Date.distantFuture) }
                .prefix(3)
                .map { task in
                    TaskEntry(id: UUID(), title: task.title, deadline: task.deadline)
                }

            if let encoded = try? JSONEncoder().encode(taskEntries) {
                sharedDefaults?.set(encoded, forKey: "tasksList")
                print("✅ Tasky uložené pre widget.")
            } else {
                print("❌ Nepodarilo sa zakódovať tasky pre widget.")
            }

            WidgetCenter.shared.reloadAllTimelines() // 🔥 automaticky refresh widget
        }}

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


// Delegát, ktorý spravuje notifikácie
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Tento metóda sa volá, keď je notifikácia pred zobrazením
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Tento metóda sa volá, keď používateľ reaguje na notifikáciu
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notifikácia bola otvorená.")
        completionHandler()
    }
}
