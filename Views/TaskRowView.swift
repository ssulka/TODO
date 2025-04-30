import SwiftUI

struct TaskRowView: View {
    @Bindable var task: TodoTask
    
    var body: some View {
        HStack {
            Button(action: { task.isDone.toggle() }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .white)
            }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(.white)
                    .strikethrough(task.isDone)
                
                // deadline
                Text(task.deadline ?? Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(task.isOverdue ? .red : .white.opacity(0.7))
                Text(task.deadline ?? Date(), style: .time)
                    .font(.caption)
                    .foregroundColor(task.isOverdue ? .red : .white.opacity(0.7))
                Text(task.category)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

