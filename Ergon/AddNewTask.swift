
import SwiftUI
import CoreData


struct AddNewTaskView: View {
    
    @EnvironmentObject var viewModel: TodoItemViewModel

    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var errorMessage: String = ""
    @State private var isSuccess: Bool = false
    @State private var showAlert: Bool = false
    @State private var exitView: Bool = false
    
    @State private var selectedDate: Date = Date()
    @State private var isDatePickerSelected: Bool = false 
    
    
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color(hex: "#1A2730")
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    
                    Text("Add New Task")
        
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(20)
                        .foregroundColor(Color(hex: "#F5F5F5"))
                        .fontWeight(.bold)
                        .font(.title)
                    
                    if !errorMessage.isEmpty{
                        Text(errorMessage)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    
                    TextField("Task Title", text: $taskName)
                        .foregroundColor(Color(hex: "#F5F5F5"))
                        .padding()
                        .background(Color(hex: "#1F2E38"))
                        .listRowBackground(Color(hex: "#1A2730"))
                        .cornerRadius(20)
                        .autocapitalization(.none)
                    
                    TextField("Task Description", text: $taskDescription)
                        .foregroundColor(Color(hex: "#F5F5F5"))
                        .padding()
                        .background(Color(hex: "#1F2E38"))
                        .listRowBackground(Color(hex: "#1A2730"))
                        .cornerRadius(20)
                        .autocapitalization(.none)
                    
                    Button(action: {isDatePickerSelected.toggle()}) {
                        HStack {
                            Text("Select Task Date")
                                .foregroundColor(Color(hex: "#A7BBC7"))
                            Spacer()
                            Text("\(selectedDate, formatter: dateFormatter)") // Display selected date
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
//                            .fontWeight(.bold)
                        .listRowBackground(Color(hex: "#1A2730"))
                        .background(Color(hex: "#1F2E38"))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    .listRowBackground(Color(hex: "#1A2730"))

                    
                    Button(action: handleAddNewTask){
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .fontWeight(.bold)
                            .cornerRadius(20)
                    }
                    
                    Button(action: handleViewClose){
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.red)
                            .fontWeight(.bold)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .alert("Task Created.", isPresented: $showAlert){
                    Button("OK"){
                        dismiss()
                    }
                }message: {
                    Text("Your task was successfully added.")
                }
                .sheet(isPresented: $isDatePickerSelected) {

                        VStack {
                            DatePicker("Select Date", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .padding()
//                                .accentColor(.white)
                                .foregroundColor(.white)
                        }
                }


            }
        
        }
    }
        
    func handleAddNewTask() {
        guard !taskName.isEmpty else {
            errorMessage = "Title is required."
            return
        }
        
        viewModel.addTodo(
            title: taskName,
            description: taskDescription,
            date: selectedDate
        )
        errorMessage = ""
        isSuccess = true
        showAlert = true
    }
        
        func handleViewClose() {
            dismiss()
        }
    
    
}

// Formatter for displaying the date in a readable format
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    AddNewTaskView()
        .environmentObject(TodoItemViewModel())

}
