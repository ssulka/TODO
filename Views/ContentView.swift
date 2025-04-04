import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoTask]

    @State private var newItem: String = ""
    @State private var isMenuOpen = false
    @State private var selectedDeadline: Date = Date().addingTimeInterval(24 * 60 * 60) // Predvolene zajtrajšok
    @State private var showDatePicker: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.opacity(0.8))
                .frame(width: 400, height: 1000)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()

            VStack {
                HStack {
                    Button(action: { isMenuOpen = true }) {
                        Text("≡")
                            .foregroundColor(.white)
                            .font(.system(size: 48))
                            .bold()
                            .padding(.horizontal, 20)
                    }
                    Spacer()
                    Text("EASYTODO™")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Spacer()
                }
                .padding(.top, 150)

                Text("Počet úloh: \(tasks.count)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                VStack(spacing: 10) {
                    TextField(" Pridaj task", text: $newItem)
                        .frame(width: 360, height: 40)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.top, 10)
                    
                    HStack {
                        Button(action: { showDatePicker.toggle() }) {
                            Label("Deadline", systemImage: "calendar")
                                .foregroundColor(.white)
                        }

                        if showDatePicker {
                            VStack {
                                // Zobrazíme DatePicker pre výber dátumu
                                DatePicker("", selection: $selectedDeadline, displayedComponents: [.date])
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .colorScheme(.dark)

                                // Zobrazíme DatePicker pre výber času
                                DatePicker("", selection: $selectedDeadline, displayedComponents: [.hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                            }
                        } else {
                            VStack {
                                Text(selectedDeadline, style: .date)
                                    .foregroundColor(.white)
                                Text(selectedDeadline, style: .time)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    Button(action: addNewItem) {
                        Text("Pridať")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)

                List {
                    Section(header: Text("TODO").foregroundColor(.white).bold()) {
                        ForEach(tasks.filter { !$0.isDone }) { task in
                            TaskRowView(task: task)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTask)
                    }

                    Section(header: Text("DONE").foregroundColor(.white).bold()) {
                        ForEach(tasks.filter { $0.isDone }) { task in
                            TaskRowView(task: task)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTask)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
        }
        .sheet(isPresented: $isMenuOpen) {
            MenuView()
        }
    }

    private func addNewItem() {
        guard !newItem.isEmpty else { return }
        
        let newTask = TodoTask(title: newItem, isDone: false, deadline: selectedDeadline.addingTimeInterval(100))
        
        modelContext.insert(newTask)
        
        // Naplánovanie notifikácie pre túto úlohu
        scheduleDeadlineNotification(for: newTask)
        
        // Resetovanie vstupov
        newItem = ""
        selectedDeadline = Date().addingTimeInterval(24 * 60 * 60) // Nastavenie predvoleného deadline na zajtrajšok
        showDatePicker = false
    }

    func scheduleDeadlineNotification(for task: TodoTask) {
        guard let deadline = task.deadline else { return }

        let content = UNMutableNotificationContent()
        content.title = "Deadline úlohy"
        content.body = "Úloha '\(task.title)' je po termíne!"
        content.sound = .default

        // Vytvorenie triggeru na konkrétny čas (deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline), repeats: false)

        // Vytvorenie požiadavky na notifikáciu
        let request = UNNotificationRequest(identifier: "\(task.id)_deadline", content: content, trigger: trigger)

        // Pridanie požiadavky na notifikáciu
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Chyba pri naplánovaní notifikácie: \(error)")
            } else {
                print("✅ Notifikácia pre úlohu '\(task.title)' naplánovaná na deadline.")
            }
        }
    }
        
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted ✅")
            } else {
                print("Notification permission denied ❌")
            }
        }
    }
    }

#Preview {
    ContentView()
}
