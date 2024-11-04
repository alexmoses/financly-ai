import SwiftUI
import SwiftData

struct BudgetDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let budget: Budget
    @State private var showingAddEntry = false
    
    var entries: [BudgetEntry] {
        budget.entries.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List {
            Section("Overview") {
                HStack {
                    Text("Budget")
                    Spacer()
                    Text(budget.amount.formatted(.currency(code: "USD")))
                        .bold()
                }
                
                HStack {
                    Text("Spent")
                    Spacer()
                    Text(budget.spent.formatted(.currency(code: "USD")))
                        .foregroundStyle(budget.spent > budget.amount ? .red : .primary)
                }
                
                HStack {
                    Text("Remaining")
                    Spacer()
                    Text(budget.remaining.formatted(.currency(code: "USD")))
                        .foregroundStyle(budget.remaining < 0 ? .red : .green)
                }
                
                ProgressView(value: budget.spent, total: budget.amount)
                    .tint(budget.percentageUsed > 90 ? .red : .blue)
            }
            
            Section("Transactions") {
                if entries.isEmpty {
                    ContentUnavailableView("No Transactions", 
                        systemImage: "dollarsign.circle",
                        description: Text("Add your first transaction using the + button")
                    )
                } else {
                    ForEach(entries) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                if let note = entry.note {
                                    Text(note)
                                        .font(.headline)
                                }
                                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(entry.amount.formatted(.currency(code: "USD")))
                                .bold()
                        }
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
        }
        .navigationTitle(budget.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddEntry = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddEntryView(budget: budget)
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            budget.spent -= entry.amount
            modelContext.delete(entry)
        }
    }
}

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let budget: Budget
    
    @State private var amount = 0.0
    @State private var note = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
                TextField("Note (optional)", text: $note)
            }
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(amount <= 0)
                }
            }
        }
    }
    
    private func saveEntry() {
        let entry = BudgetEntry(amount: amount, note: note.isEmpty ? nil : note, budget: budget)
        modelContext.insert(entry)
        budget.spent += amount
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Budget.self, BudgetEntry.self, configurations: config)
        
        // Create sample budget for preview
        let budget = Budget(name: "Test Budget", amount: 1000, category: .food)
        container.mainContext.insert(budget)
        
        // Add some sample transactions
        let entry1 = BudgetEntry(amount: 50, note: "Groceries", budget: budget)
        let entry2 = BudgetEntry(amount: 25, note: "Coffee", budget: budget)
        container.mainContext.insert(entry1)
        container.mainContext.insert(entry2)
        budget.spent = 75
        
        return NavigationStack {
            BudgetDetailView(budget: budget)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}