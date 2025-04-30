import Foundation
import SwiftData

@Model
final class TodoTask {
    var id: UUID
    var title: String
    var isDone: Bool
    var deadline: Date?
    var category: String
    var position: Int = 0
    
    init(title: String, isDone: Bool = false, deadline: Date? = nil, category: String = "General", position: Int = 0) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
        self.deadline = deadline
        self.category = category
        self.position = position
    }

    // Vlastnosť isOverdue na výpočet, či je úloha po termíne
    var isOverdue: Bool {
        guard let deadline = deadline else { return false }
        return !isDone && deadline < Date()
    
    }
}


