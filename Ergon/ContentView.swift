import SwiftUI

struct ContentView: View {
    
    @State private var showAddNewTask: Bool = false
    @EnvironmentObject var viewModel: TodoItemViewModel

    var body: some View {
        NavigationStack {
            
            ZStack{
                Color(hex: "#1A2730")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: -20) {
                        Text("Ergon")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .fontWeight(.bold)
                            .font(.title)
                        
                        Text("Your personal todo-list app")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                    VStack(spacing: 20) {
                        
                        Button(action: {showAddNewTask = true}){
                            Text("Add New Task")
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                                .padding()
                                .foregroundColor(Color(hex: "#F5F5F5"))
                                .background(.blue)
                                .fontWeight(.bold)
                                .cornerRadius(20)
                        }
                        
                        NavigationLink(destination: AllTasksView()) {
                            Text("View All Tasks")
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                                .padding()
                                .foregroundColor(Color(hex: "#F5F5F5"))
                                .background(.orange)
                                .fontWeight(.bold)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showAddNewTask) {
                    AddNewTaskView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(TodoItemViewModel())
}
