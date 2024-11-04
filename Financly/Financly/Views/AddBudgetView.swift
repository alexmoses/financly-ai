import SwiftUI
import SwiftData

struct AddBudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var amount = 0.0
    @State private var selectedCategory = Category.other
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Budget Name", text: $name)
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Label(category.rawValue, systemImage: category.icon)
                            .tag(category)
                    }
                }
            }
            .navigationTitle("New Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(name.isEmpty || amount <= 0)
                }
            }
        }
    }
    
    private func saveBudget() {
        let budget = Budget(name: name, amount: amount, category: selectedCategory)
        modelContext.insert(budget)
        dismiss()
    }
} 