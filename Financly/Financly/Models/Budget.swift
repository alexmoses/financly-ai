import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID
    var name: String
    var amount: Double
    var spent: Double
    var category: Category
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var entries: [BudgetEntry]
    
    init(name: String, amount: Double, category: Category) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.spent = 0
        self.category = category
        self.createdAt = Date()
        self.entries = []
    }
    
    var remaining: Double {
        amount - spent
    }
    
    var percentageUsed: Double {
        (spent / amount) * 100
    }
}

enum Category: String, Codable, CaseIterable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food"
    case utilities = "Utilities"
    case insurance = "Insurance"
    case healthcare = "Healthcare"
    case savings = "Savings"
    case entertainment = "Entertainment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .transportation: return "car.fill"
        case .food: return "cart.fill"
        case .utilities: return "bolt.fill"
        case .insurance: return "shield.fill"
        case .healthcare: return "heart.fill"
        case .savings: return "banknote.fill"
        case .entertainment: return "tv.fill"
        case .other: return "square.fill"
        }
    }
} 