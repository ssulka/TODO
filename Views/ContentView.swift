import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoTask]
    @AppStorage("backgroundColorHex") private var backgroundColorHex: String = "#0000FF"

    @State private var newItem: String = ""
    @State private var isMenuOpen = false
    @State private var selectedDeadline: Date = Date().addingTimeInterval(24 * 60 * 60)
    @State private var showDatePicker: Bool = false

    var todoTasks: [TodoTask] {
        tasks.filter { !$0.isDone }
    }

    var doneTasks: [TodoTask] {
        tasks.filter { $0.isDone }
    }


    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: backgroundColorHex).opacity(0.8))
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

                Text("Number of tasks: \(todoTasks.count)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                VStack(spacing: 10) {
                    TextField(" Add task", text: $newItem)
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
                        Text("Add")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)

                List {
                    Section(header: Text("TODO").foregroundColor(.white).bold()) {
                        ForEach(todoTasks) { task in
                            TaskRowView(task: task)
                                .listRowBackground(Color.clear)
                        }
                        .onMove(perform: moveTodoTask)
                        .onDelete(perform: deleteTodoTask)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(10)
                .padding()

                List {
                    Section(header: Text("DONE").foregroundColor(.white).bold()) {
                        ForEach(doneTasks) { task in
                            TaskRowView(task: task)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteDoneTask)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
        }
        //.onAppear(perform: loadTasks)
        .sheet(isPresented: $isMenuOpen) {
            MenuView()
        }
    }

    private func addNewItem() {
        guard !newItem.isEmpty else { return }

        let newTask = TodoTask(title: newItem, isDone: false, deadline: selectedDeadline)
        modelContext.insert(newTask)
        try? modelContext.save()

        let allTasks = try? modelContext.fetch(FetchDescriptor<TodoTask>())
        TODOApp.saveTasksForWidget(tasks: allTasks ?? [])

        newItem = ""
        selectedDeadline = Date().addingTimeInterval(24 * 60 * 60)
        showDatePicker = false

        //loadTasks()
    }

    private func moveTodoTask(from source: IndexSet, to destination: Int) {
        var newOrder = todoTasks
        newOrder.move(fromOffsets: source, toOffset: destination)
        
    }

    private func deleteTodoTask(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(todoTasks[index])
        }
        //loadTasks()
    }

    private func deleteDoneTask(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(doneTasks[index])
        }
        //loadTasks()
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
