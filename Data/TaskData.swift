import SwiftUI

struct TaskData: Identifiable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var deadline: Optional<Date>
   // var position: Int = 0
    var category: String
    
    
}
