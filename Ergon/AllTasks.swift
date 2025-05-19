import SwiftUI
import CoreData

struct AllTasksView: View {
    
    @EnvironmentObject var viewModel: TodoItemViewModel
    
    @Environment(\.editMode) private var editMode
    
    @State private var searchText: String = ""
    @State private var selectedDate: Date = Date() // Filter by selected date
    @State private var isDatePickerPresented: Bool = false // Show DatePicker modal
    @State private var selectedTodo: TodoItem? = nil
    
    
    @State private var showTemplateModal: Bool = false
    @State private var showEditTemplate: Bool = false
    @State private var selectedTemplateForEdit: TaskTemplate? = nil
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: "#1A2730")
                            .ignoresSafeArea()
                
                VStack(spacing: 10){
                    VStack(spacing: -30){
                        
                        Text("Tasks")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .fontWeight(.bold)
                            .font(.title)
                        
                        
                        Text("\(formatedDate(selectedDate))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: "#A7BBC7"))
                            .fontWeight(.bold)
                            .font(.headline)
                    }
                    
                    
                    // Search Bar for Task Title
                    ZStack(alignment: .leading) {
                        
                        TextField("Search Task by Title", text: $searchText)
                            .padding()
                            .foregroundColor(Color(hex: "#A7BBC7"))
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal)
                    
                    
                    
                    // Button to trigger DatePicker modal
                    Button(action: {
                        isDatePickerPresented.toggle()
                    }) {
                        HStack {
                            Text("Select Task Date")
                                .foregroundColor(Color(hex: "#A7BBC7"))
                            Spacer()
                            Text("\(selectedDate, formatter: dateFormatter)") // Display selected date
                                .foregroundColor(Color(hex: "#A7BBC7"))
                            
                        }
                        .padding()
                        .background(Color(hex: "#1F2E38"))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                    
                    if !viewModel.taskTemplates.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.taskTemplates) { template in
                                    Button(action: {
                                        viewModel.applyTemplate(template, to: selectedDate)
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(template.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(hex: "#F5F5F5"))
                                            
                                            Text(template.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .lineLimit(1) // 👈 Truncate long descriptions
                                                .truncationMode(.tail)
                                        }
                                        .frame(width: 140, height: 40)
                                        .padding(10)
                                        .background(Color(hex: "#A7BBC7").opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                    .contextMenu{
                                        Button("Edit"){
                                            selectedTemplateForEdit = template
                                            showEditTemplate = true
                                        }
                                        
                                        Button("Delete", role: .destructive){
                                            viewModel.deleteTemplate(template) 
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .background(Color(hex: "#1A2730"))
                        }
                        .sheet(item: selectedTemplateForEdit){ template in
                            EditTemplateView(
                                template: template
                            ){
                                updatedTitle, updatedDesc in
                                viewModel.updateTemplate(template.id, title: updatedTitle, description: UpdatedDesc)
                            }
                        }
                    }
                    
                    Button("Add Template") {
                        showTemplateModal = true
                    }
                    .foregroundColor(Color(hex: "#A7BBC7"))
                    .sheet(isPresented: $showTemplateModal) {
                        AddTemplateView { title, description, time in
                            viewModel.addTemplate(title: title, description: description, defaultTime: time)
                        }
                    }
                    
                    
                    // List of filtered tasks
                    
                    ZStack{
                        
                        Color(hex: "#1A2730").ignoresSafeArea()
                        
                        VStack{
                            List {
                                ForEach(filteredTasks) { todo in
                                    taskRowView(for: todo)
                                        .listRowInsets(.init()) 
//                                        .listRowBackground(Color(hex: "#172228")) 
                                }
                                .onMove { source, destination in
                                    viewModel.reorderFiltered(for: selectedDate, fromOffsets: source, toOffset: destination)
                                }
                            }
                            .listStyle(.plain) // <- removes section insets and background card
                            .scrollContentBackground(.hidden) // <- removes default white background
                            .listRowInsets(EdgeInsets()) // <- ensures full width
                            .listRowBackground(Color(hex: "#1A2730")) // <- ensures dark row bg
                            .background(Color(hex: "#1A2730")) // <- background behind the whole list
                            
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        withAnimation {
                                            editMode?.wrappedValue = (editMode?.wrappedValue == .active) ? .inactive : .active
                                        }
                                    }) {
                                        Text(editMode?.wrappedValue == .active ? "Done" : "Rearrange")                            .foregroundColor(Color(hex: "#A7BBC7"))
                                        
                                    }
                                }
                            }
                            .sheet(isPresented: $isDatePickerPresented) {
                                // DatePicker modal for task date selection
                                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding()
                            }
                            .sheet(item: $selectedTodo) { todoToEdit in
                                EditTask(todoItem: todoToEdit) { updatedTitle, updatedDescription, updatedDate in
                                    viewModel.update(id: todoToEdit.id, title: updatedTitle, description: updatedDescription, date: updatedDate)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Filter tasks based on title and selected date
    private var filteredTasks: [TodoItem] {
        let calendar = Calendar.current
        return viewModel.todos
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.sortIndex < $1.sortIndex }
    }
    
    @ViewBuilder
    private func taskRowView(for todo: TodoItem) -> some View {
        TaskRow(
            todo: todo,
            onEdit: {
                selectedTodo = todo
            },
            onDelete: {
                if let index = viewModel.todos.firstIndex(where: { $0.id == todo.id }) {
                    viewModel.delete(at: IndexSet(integer: index))
                }
            },
            onToggle: {
                viewModel.toggleDone(for: todo)
            }
        )
    }


    

}



#Preview {
    AllTasksView()
        .environmentObject(TodoItemViewModel())
}
