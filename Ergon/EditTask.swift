import SwiftUI
import Foundation

struct EditTask: View {
    
    var todoItem: TodoItem
    var onSave: (String, String, Date) -> Void
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    
    @State private var isDatePickerSelected: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        todoItem: TodoItem,
        onSave: @escaping (String, String, Date) -> Void
    ) {
        self.todoItem = todoItem
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#1A2730")
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
                    Text("Edit Task")
        
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(20)
                        .foregroundColor(Color(hex: "#F5F5F5"))
                        .fontWeight(.bold)
                        .font(.title)
                    
                    Form {
                        TextField("Title", text: $title)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .padding()
                            .background(Color(hex: "#1F2E38"))
                            .listRowBackground(Color(hex: "#1A2730"))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                        
                        
                        TextField("Description", text: $description)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .padding()
                            .background(Color(hex: "#1F2E38"))
                            .listRowBackground(Color(hex: "#1A2730"))
                            .cornerRadius(20)
                            .autocapitalization(.none)

                        
                        Button(action: {
                            isDatePickerSelected.toggle()
                        }) {
                            HStack {
                                Text("Select Task Date")
                                    .foregroundColor(Color(hex: "#F5F5F5"))
                                Spacer()
                                Text("\(date, formatter: dateFormatter)") // Display selected date
                                    .foregroundColor(Color(hex: "#F5F5F5"))
                                
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
                    }
                    .scrollContentBackground(.hidden)
                    .onAppear {
                        if title.isEmpty {
                            title = todoItem.title
                            description = todoItem.description
                            date = todoItem.date
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                onSave(title, description, date)
                                dismiss()
                            }
                            .foregroundColor(.green)
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .sheet(isPresented: $isDatePickerSelected) {
                        
                        VStack {
                            DatePicker("Select Date", selection: $date, in: Date()..., displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .padding()
                                .foregroundColor(.white)
                        }
                        
                    }
                }
                .listRowBackground(Color(hex: "#1A2730"))
                .background(Color(hex: "#1A2730"))
            }
        }
    }
}


#Preview {
    EditTask(
        todoItem: TodoItem(
            title: "Buy Groceries",
            description: "Milk, Eggs, Bread",
            date: Date()
        ),
        onSave: { title, description, date in
            // Preview handler
            print("Saved: \(title), \(description), \(date)")
        }
    )
}
