import SwiftUI

struct AddTemplateView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var time: Date = Date()
    @State private var includeTime: Bool = false

    @Environment(\.dismiss) private var dismiss

    var onSave: (String, String, Date?) -> Void

    var body: some View {
        NavigationStack {
            
            ZStack {
                Color(hex: "#1A2730")
                    .ignoresSafeArea()
                
                
                
                Form {
                    Section(
                        header: Text("Template Info")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#F5F5F5"))) {
                                
                                
                        TextField("Title", text: $title)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .padding()
                            .background(Color(hex: "#1F2E38"))
                            .listRowBackground(Color(hex: "#1A2730"))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                        
                        TextField("Description", text: $description)
                            .foregroundColor(Color(hex: "#F5F5F5"))
                            .accentColor(Color(.white))
                            .padding()
                            .background(Color(hex: "#1F2E38"))
                            .listRowBackground(Color(hex: "#1A2730"))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                    }
                    
//                    Section(header: Text("Default Time (Optional)")) {
//                        Toggle("Include Default Time", isOn: $includeTime)
//                        if includeTime {
//                            DatePicker("Time", selection: $time, displayedComponents: [.hourAndMinute])
//                        }
//                    }
                }
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let selectedTime = includeTime ? time : nil
                            onSave(title, description, selectedTime)
                            dismiss()
                        }
                        .foregroundColor(Color(.green))
                        .disabled(title.isEmpty)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(Color(.red))

                    }
                }
            }
        }
    }
}


#Preview {
    AddTemplateView(
        onSave: { title, description, time in
            // Preview handler
            print("Saved: \(title), \(description), \(time)")
        }
    )
}
