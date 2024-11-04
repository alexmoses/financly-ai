//
//  FinanclyApp.swift
//  Financly
//
//  Created by Alex Moses on 4/11/2024.
//

import SwiftUI
import SwiftData

@main
struct FinanclyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Budget.self, BudgetEntry.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
