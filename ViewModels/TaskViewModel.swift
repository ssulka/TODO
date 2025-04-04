// TaskViewModel.swift
import SwiftUI
import SwiftData

class TaskViewModel: ObservableObject {
    func toggleTaskCompletion(task: TodoTask) {
        task.isDone.toggle()
    }
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🚀 Test Notification"
        content.body = "This is a test notification after 5 seconds!"
        content.sound = .default

        // Trigger in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error)")
            } else {
                print("Test notification scheduled successfully ✅")
            }
        }
    }
}
