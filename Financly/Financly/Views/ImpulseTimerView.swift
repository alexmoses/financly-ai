import SwiftUI

struct ImpulseTimerView: View {
    @State private var timeRemaining = 10
    @State private var isTimerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("Think Before You Buy")
                    .font(.title)
                    .bold()
                
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
            }
            .padding()
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