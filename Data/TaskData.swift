import SwiftUI

struct TaskData: Identifiable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var deadline: Optional<Date>
}
