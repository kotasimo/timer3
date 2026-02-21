import SwiftUI
import Combine

struct ContentView: View {
    @State private var isRunning = false
    @State private var startDate: Date? = nil
    @State private var elapsed: TimeInterval = 0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 24) {
            Text(isRunning ? "計測" : "停止中")
                .font(.title2)
                .bold()
            
            Text(formatTime(elapsed))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
            
            Button {
                toggle()
            } label: {
                Text(isRunning ? "STOP" : "START")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            guard isRunning, let startDate else { return }
            elapsed = Date().timeIntervalSince(startDate)
        }
    }
    
    private func toggle() {
        if isRunning {
            // stop
            isRunning = false
            startDate = nil
        } else {
            isRunning = true
            startDate = Date()
            elapsed = 0
        }
    }
    
    private func formatTime(_ t: TimeInterval) -> String {
        let total = Int(t)
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }
}
