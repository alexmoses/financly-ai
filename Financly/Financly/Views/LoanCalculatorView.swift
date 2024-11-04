import SwiftUI

struct LoanCalculatorView: View {
    @State private var loanAmount: Double = 500000
    @State private var interestRate: Double = 3.5
    @State private var loanTerm: Double = 30
    @State private var extraPayment: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Loan Details") {
                    HStack {
                        Text("Loan Amount")
                        Spacer()
                        TextField("Amount", value: $loanAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Interest Rate")
                        Spacer()
                        TextField("Rate", value: $interestRate, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Loan Term (Years)")
                        Spacer()
                        TextField("Years", value: $loanTerm, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Extra Payments") {
                    HStack {
                        Text("Monthly Extra")
                        Spacer()
                        TextField("Extra", value: $extraPayment, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Summary") {
                    HStack {
                        Text("Monthly Payment")
                        Spacer()
                        Text("$0")
                            .bold()
                    }
                    
                    HStack {
                        Text("Total Interest")
                        Spacer()
                        Text("$0")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Loan Calculator")
        }
    }
} 