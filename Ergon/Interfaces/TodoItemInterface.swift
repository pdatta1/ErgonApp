
import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var date: Date
    var sortIndex: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        date: Date,
        sortIndex: Int = 0
    ){
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.date = date
        self.sortIndex = sortIndex 
    }
}


struct TaskTemplate: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var defaultTime: Date? // Optional time (e.g., 9am)

    init(id: UUID = UUID(), title: String, description: String, defaultTime: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.defaultTime = defaultTime
    }
}



