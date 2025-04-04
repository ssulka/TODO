import Foundation
import SwiftData

@Model
final class TodoTask {
    var title: String
    var isDone: Bool
    var deadline: Date?
    
    init(title: String, isDone: Bool = false, deadline: Date? = nil) {
        self.title = title
        self.isDone = isDone
        self.deadline = deadline
    }

    // Vlastnosť isOverdue na výpočet, či je úloha po termíne
    var isOverdue: Bool {
        guard let deadline = deadline else { return false }
        return !isDone && deadline < Date()  // Úloha je po termíne, ak nie je dokončená a termín je už minulý
    }
}


