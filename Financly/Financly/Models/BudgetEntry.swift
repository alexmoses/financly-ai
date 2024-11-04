import Foundation
import SwiftData

@Model
final class BudgetEntry {
    var id: UUID
    var amount: Double
    var date: Date
    var note: String?
    @Relationship(inverse: \Budget.entries) var budget: Budget?
    
    init(amount: Double, note: String? = nil, budget: Budget? = nil) {
        self.id = UUID()
        self.amount = amount
        self.date = Date()
        self.note = note
        self.budget = budget
    }
} 