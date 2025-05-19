import SwiftUI
import Foundation

struct TaskRow: View {
    var todo: TodoItem
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onToggle: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#F5F5F5"))

                Text(todo.description)
                    .font(.body)
                    .foregroundColor(Color(hex: "#A7BBC7"))
            }

            Spacer()

            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(todo.isCompleted ? .green : .gray)
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity) // ✅ this makes the background full width
        .background(Color(hex: "#1F2E38"))
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.orange)

            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }


    }
}

