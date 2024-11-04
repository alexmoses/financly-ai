import SwiftUI

struct ImpulseTimerView: View {
    @State private var timeRemaining = 10
    @State private var isTimerRunning = false
    @State private var impulseAmount = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Average annual S&P 500 return (historically around 10%)
    private let annualReturnRate = 0.10
    private let investmentYears = 2.0
    
    var potentialInvestmentValue: Double {
        // Compound interest formula: A = P(1 + r)^t
        // where A is final amount, P is principal, r is interest rate, t is time
        return impulseAmount * pow(1 + annualReturnRate, investmentYears)
    }
    
    var potentialGain: Double {
        potentialInvestmentValue - impulseAmount
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Text("Think Before You Buy")
                        .font(.title)
                        .bold()
                    
                    VStack(spacing: 20) {
                        TextField("Amount you want to spend", value: $impulseAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    
                        if impulseAmount > 0 {
                            VStack(spacing: 10) {
                                Text("If invested in S&P 500 for 2 years:")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                
                                Text(potentialInvestmentValue.formatted(.currency(code: "USD")))
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("Potential gain: \(potentialGain.formatted(.currency(code: "USD")))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(.blue)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(timeRemaining) / 10)
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: timeRemaining)
                        
                        Text("\(timeRemaining)")
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(width: 200, height: 200)
                    
                    Button(action: startTimer) {
                        Text(isTimerRunning ? "Reset" : "Start Timer")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    if timeRemaining == 0 && impulseAmount > 0 {
                        VStack(spacing: 10) {
                            Text("Time's up! Consider this:")
                                .font(.headline)
                            Text("Instead of spending \(impulseAmount.formatted(.currency(code: "USD"))), you could potentially have \(potentialInvestmentValue.formatted(.currency(code: "USD"))) in 2 years through S&P 500 investment.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Impulse Timer")
            .onReceive(timer) { _ in
                if isTimerRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    isTimerRunning = false
                }
            }
        }
    }
    
    func startTimer() {
        timeRemaining = 10
        isTimerRunning = true
    }
}

#Preview {
    ImpulseTimerView()
} 