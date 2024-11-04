//
//  ContentView.swift
//  Financly
//
//  Created by Alex Moses on 4/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "dollarsign.circle.fill")
                }
            
            LoanCalculatorView()
                .tabItem {
                    Label("Loan", systemImage: "house.fill")
                }
            
            ImpulseTimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView()
}
