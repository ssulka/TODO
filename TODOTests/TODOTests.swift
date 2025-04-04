import Testing
@testable import TODO
import Foundation

struct TODOTests {

    @Test func example() async throws {
        let viewModel = TaskViewModel()
        let task = TodoTask(title: "Test task")
        viewModel.toggleTaskCompletion(task: task)
        assert(task.isDone == true)
    }
    
    @Test func testNotification() async throws {
        let viewModel = TaskViewModel()
        viewModel.scheduleTestNotification()
    }
    
    @Test func testIsOverdue() async throws {
        let task = TodoTask(title: "Test task", deadline: Date().addingTimeInterval(-3600))
        assert(task.isOverdue == true)
    }
    
    @Test func testIsNotOverdue() async throws {
        let task = TodoTask(title: "Test task", deadline: Date().addingTimeInterval(3600))
        assert(task.isOverdue == false)
    }

}
