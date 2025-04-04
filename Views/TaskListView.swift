// TaskListView.swift
import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoTask]
    
    var body: some View {
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
    }
    
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let tasksToDelete = tasks.filter { !$0.isDone }
            modelContext.delete(tasksToDelete[index])
        }
    }
}
