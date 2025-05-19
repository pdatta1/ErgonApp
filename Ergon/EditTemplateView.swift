
import Foundation
import SwiftUI


struct EditTemplateView: View {
    
    
    var templateItem: TaskTemplate
    var onSave: (String, String) -> Void
    
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    init(
        templateItem: TaskTemplate,
        onSave: @escaping (String, String) -> Void
    ){
        self.templateItem = templateItem
        self.onSave = onSave
    }
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: "#1A2730").ignoresSafeArea()
                
                VStack(spacing: 20){
                    Text("Edit Template")
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
                    }
                    .scrollContentBackground(.hidden)
                    .onAppear{
                        if title.isEmpty{
                            title = templateItem.title
                            description = templateItem.description
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .confirmationAction){
                            Button("Save"){
                                onSave(title, description)
                                dismiss()
                            }.foregroundColor(.green)
                        }
                        
                        ToolbarItem(placement: .destructiveAction){
                            Button("Cancel"){
                                dismiss()
                            }.foregroundColor(.red)
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
    EditTemplateView(
        templateItem: TaskTemplate(title: "Go Dancing", description: "Do some crip walking"),
        onSave: {
            tile, description in
                print("hello")
        }
        
    )
}

