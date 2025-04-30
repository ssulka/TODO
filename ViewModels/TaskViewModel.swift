// TaskViewModel.swift
import SwiftUI
import SwiftData

class TaskViewModel: ObservableObject {
    func toggleTaskCompletion(task: TodoTask) {
        task.isDone.toggle()
    }

}
