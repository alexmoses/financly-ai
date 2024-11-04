import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var budgets: [Budget]
    @State private var showingAddBudget = false
    
    var totalBudget: Double {
        budgets.reduce(0) { $0 + $1.amount }
    }
    
    var totalSpent: Double {
        budgets.reduce(0) { $0 + $1.spent }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    HStack {
                        Text("Total Budget")
                        Spacer()
                        Text(totalBudget.formatted(.currency(code: "USD")))
                            .bold()
                    }
                    
                    HStack {
                        Text("Spent")
                        Spacer()
                        Text(totalSpent.formatted(.currency(code: "USD")))
                            .foregroundStyle(.red)
                    }
                }
                
                Section("Categories") {
                    ForEach(budgets) { budget in
                        NavigationLink {
                            BudgetDetailView(budget: budget)
                        } label: {
                            BudgetRowView(budget: budget)
                        }
                    }
                    .onDelete(perform: deleteBudgets)
                }
            }
            .navigationTitle("Budget")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddBudget = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView()
            }
        }
    }
    
    private func deleteBudgets(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(budgets[index])
        }
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        HStack {
            Label(budget.name, systemImage: budget.category.icon)
            Spacer()
            VStack(alignment: .trailing) {
                Text(budget.amount.formatted(.currency(code: "USD")))
                    .bold()
                ProgressView(value: budget.spent, total: budget.amount)
                    .tint(budget.percentageUsed > 90 ? .red : .blue)
                    .frame(width: 100)
            }
        }
    }
} 