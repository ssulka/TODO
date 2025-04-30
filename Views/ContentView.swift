import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\TodoTask.position)]) private var tasks: [TodoTask]

    @AppStorage("backgroundColorHex") private var backgroundColorHex: String = "#00AA00"
    @State private var selectedCategory: String = "General"
    @State private var newItem: String = ""
    @State private var isMenuOpen = false
    @State private var selectedDeadline: Date = Date().addingTimeInterval(24 * 60 * 60)
    @State private var showDatePicker: Bool = false

    @State private var taskBeingEdited: TodoTask? = nil
    @State private var editedTitle: String = ""
    @State private var editedDeadline: Date = Date()
    @State private var editedCategory: String = "General"
    let categories = ["General", "Work", "Personal", "School"]
    var todoTasks: [TodoTask] {
        tasks.filter { !$0.isDone }
    }

    var doneTasks: [TodoTask] {
        tasks.filter { $0.isDone }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: backgroundColorHex).opacity(0.8)
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    HStack {
                        Button(action: { isMenuOpen = true }) {
                            Text("≡")
                                .foregroundColor(.white)
                                .font(.system(size: 36))
                                .bold()
                                .padding(.horizontal)
                        }
                        Spacer()
                        
                        Text("EASYTODO™")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.horizontal, 0)
                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal, -20)
                    

                    Text("Number of tasks: \(todoTasks.count)")
                        .font(.headline)
                        .foregroundColor(.white)

                    // Add new task
                    VStack(spacing: 10) {
                        TextField(" Add task", text: $newItem)
                            .frame(height: 40)
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 1)
                            )

                        HStack {
                            Button(action: { showDatePicker.toggle() }) {
                                Label("Deadline", systemImage: "calendar")
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            if showDatePicker {
                                VStack {
                                    DatePicker("", selection: $selectedDeadline, displayedComponents: [.date])
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                    DatePicker("", selection: $selectedDeadline, displayedComponents: [.hourAndMinute])
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                }
                            } else {
                                VStack(alignment: .trailing) {
                                    Text(selectedDeadline, style: .date)
                                        .foregroundColor(.white)
                                    Text(selectedDeadline, style: .time)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        Button(action: addNewItem) {
                            Text("Add")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }

                    // Task list
                    List {
                        if !todoTasks.isEmpty {
                            Section(header: Text("TODO").foregroundColor(.white)) {
                                ForEach(todoTasks) { task in
                                    taskRow(task)
                                        .listRowBackground(Color.clear)
                                }
                                .onMove(perform: moveTodoTask)
                                .onDelete(perform: deleteTodoTask)
                            }
                        }

                        if !doneTasks.isEmpty {
                            Section(header: Text("DONE").foregroundColor(.white)) {
                                ForEach(doneTasks) { task in
                                    taskRow(task)
                                        .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: deleteDoneTask)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.plain)
                    .listRowBackground(Color.clear)
                    .padding(.top, -10)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isMenuOpen) {
                MenuView()
            }
            .task {
                assignMissingPositionsIfNeeded()
            }
            .sheet(item: $taskBeingEdited) { task in
                VStack(spacing: 20) {
                    Text("Edit Task")
                        .font(.title)
                        .padding()

                    TextField("Title", text: $editedTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    DatePicker("Deadline", selection: $editedDeadline, displayedComponents: [.date, .hourAndMinute])
                        .padding()
                    Picker("Category", selection: $editedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button("Save Changes") {
                        task.title = editedTitle
                        //task.category = editedCategory
                        task.deadline = editedDeadline
                        task.category = editedCategory
                        try? modelContext.save()
                        taskBeingEdited = nil
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Cancel") {
                        taskBeingEdited = nil
                    }
                    .padding()
                }
                .padding()
            }
        }
    }

    // MARK: - Task Row View
    private func taskRow(_ task: TodoTask) -> some View {
        HStack {
            Button(action: {
                toggleDone(task: task)
            }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.white)
            }
            .buttonStyle(BorderlessButtonStyle())

            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(.white)
                Text(task.category)
                    .foregroundColor(categoryColor(for: task.category))
                    .font(.caption)
                    
                if let deadline = task.deadline {
                    Text(deadline, style: .date)
                        .font(.caption)
                        .foregroundColor(task.isOverdue ? .red : .white.opacity(0.7))
                    Text(deadline, style: .time)
                        .font(.caption)
                        .foregroundColor(task.isOverdue ? .red : .white.opacity(0.7))
                }

            }
        }
        .onTapGesture {
            taskBeingEdited = task
            editedTitle = task.title
            editedDeadline = task.deadline ?? Date()
            editedCategory = task.category
        }
    }

    // MARK: - Logic
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Work":
            return .yellow
        case "Personal":
            return .green.opacity(0.9)
        case "School":
            return .cyan.opacity(0.8)
        case "General":
            return .white
        default:
            return .white.opacity(0.7)
        }
    }



    private func addNewItem() {
        guard !newItem.isEmpty else { return }

        let newTask = TodoTask(
            title: newItem,
            isDone: false,
            deadline: selectedDeadline,
            category: selectedCategory
        )
        modelContext.insert(newTask)
        try? modelContext.save()

        scheduleNotification(for: newTask) // ⬅️ pridaj túto riadku

        let allTasks = try? modelContext.fetch(FetchDescriptor<TodoTask>())
        TODOApp.saveTasksForWidget(tasks: allTasks ?? [])

        newItem = ""
        selectedDeadline = Date().addingTimeInterval(24 * 60 * 60)
        showDatePicker = false
        selectedCategory = "General"
    }


    private func moveTodoTask(from source: IndexSet, to destination: Int) {
        var filtered = tasks.filter { !$0.isDone }
        filtered.move(fromOffsets: source, toOffset: destination)

        for (index, task) in filtered.enumerated() {
            task.position = index
        }

        try? modelContext.save()
    }

    
    private func assignMissingPositionsIfNeeded() {
        let sorted = tasks.sorted { $0.position < $1.position }
        for (index, task) in sorted.enumerated() {
            task.position = index
        }
        try? modelContext.save()
    }
    // notification
    private func scheduleNotification(for task: TodoTask) {
        guard let deadline = task.deadline else { return }

        let notificationTime = deadline.addingTimeInterval(-3600)

        if notificationTime < Date() {
            
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "DEADLINE REMINDER"
        content.body = "Task „\(task.title)“ will end in 1 hour."
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            
        }
    }



    private func deleteTodoTask(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todoTasks[index])
        }
    }

    private func deleteDoneTask(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(doneTasks[index])
        }
    }

    private func toggleDone(task: TodoTask) {
        task.isDone.toggle()
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
}
