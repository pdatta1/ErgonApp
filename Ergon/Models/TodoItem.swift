import Foundation

class TodoItemViewModel: ObservableObject {
    
    @Published var todos: [TodoItem] = []
    @Published var taskTemplates: [TaskTemplate] = []

    private let saveKey: String = "todos.json"
    private let templateKey = "task_templates.json"

    init(){
        loadTodos()
        loadTemplates()
    }
    
    func loadTodos(){
        let url = getDocumentsDirectory().appendingPathComponent(saveKey)
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data){
            self.todos = decoded
        }
    }
    
    func addTodo(title: String, description: String, date: Date) {
        let maxSort = todos
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .map(\.sortIndex)
            .max() ?? 0

        let newTodo = TodoItem(
            title: title,
            description: description,
            date: date,
            sortIndex: maxSort + 1
        )
        todos.append(newTodo)
        saveTodos()
    }

    func toggleDone(for todo: TodoItem){
        if let index = todos.firstIndex(where: { $0.id == todo.id }){
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func delete(at offsets: IndexSet){
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    func update(id: UUID, title: String, description: String, date: Date){
        if let index = todos.firstIndex(where: { $0.id == id }){
            todos[index].title = title
            todos[index].description = description
            todos[index].date = date
            saveTodos()
        }
    }
    

    func reorderFiltered(for date: Date, fromOffsets source: IndexSet, toOffset destination: Int) {
        let calendar = Calendar.current

        // Get filtered tasks sorted by current sortIndex
        var filtered = todos
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.sortIndex < $1.sortIndex }

        // Move items locally
        filtered.move(fromOffsets: source, toOffset: destination)

        // Reassign new sortIndex values back into master todos
        for (i, task) in filtered.enumerated() {
            if let idx = todos.firstIndex(where: { $0.id == task.id }) {
                todos[idx].sortIndex = i
            }
        }

        saveTodos()
    }

    
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        saveTodos()
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // Task Template Management
    func saveTemplates() {
        let url = getDocumentsDirectory().appendingPathComponent(templateKey)
        if let data = try? JSONEncoder().encode(taskTemplates) {
            try? data.write(to: url)
        }
    }

    func loadTemplates() {
        let url = getDocumentsDirectory().appendingPathComponent(templateKey)
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([TaskTemplate].self, from: data) {
            taskTemplates = decoded
        }
    }

    func addTemplate(title: String, description: String, defaultTime: Date?) {
        let newTemplate = TaskTemplate(title: title, description: description, defaultTime: defaultTime)
        taskTemplates.append(newTemplate)
        saveTemplates()
    }

    func applyTemplate(_ template: TaskTemplate, to date: Date) {
        let taskDate = template.defaultTime.map {
            Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $0),
                                  minute: Calendar.current.component(.minute, from: $0),
                                  second: 0,
                                  of: date)
        } ?? date

        addTodo(title: template.title, description: template.description, date: taskDate ?? date)
    }
    
    func deleteTemplate(_ template: TaskTemplate) {
        if let index = taskTemplates.firstIndex(where: { $0.id == template.id }) {
            taskTemplates.remove(at: index)
            saveTodos() // if needed
        }
    }
    
    func updateTemplate(id: UUID, title: String, description: String){
        if let index = taskTemplates.firstIndex(where: {$0.id == id}){
            taskTemplates[index].title = title
            taskTemplates[index].description = description
            saveTemplates()
        }
    }
    
    func saveTodos() {
        let url = getDocumentsDirectory().appendingPathComponent(saveKey)
        if let data = try? JSONEncoder().encode(todos) {
            try? data.write(to: url)
        }
    }
    



}

