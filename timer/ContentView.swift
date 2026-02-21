import SwiftUI
import Combine

struct ContentView: View {
    enum Mode { case focus, rest }
    
    @State private var mode: Mode = .focus
    @State private var startDate: Date = Date()

    @State private var focusTotal: TimeInterval = 0
    @State private var restTotal: TimeInterval = 0

    var body: some View {
        let now = Date()
        let currentElapsed = now.timeIntervalSince(startDate)

        VStack(spacing: 24) {
            Text(mode == .focus ? "集中" : "休憩")
                .font(.title)
                .bold()

            // 「今のモードの経過時間」
            TimelineView(.periodic(from: .now, by: 1)) { _ in
                let liveElapsed = Date().timeIntervalSince(startDate)
                Text(formatTime(liveElapsed))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }

            Button {
                switchMode(at: now)
            } label: {
                Text(mode == .focus ? "休憩に切り替える" : "集中に戻る")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)

            VStack(spacing: 8) {
                Text("今日の合計")
                    .font(.headline)

                HStack {
                    Text("集中")
                    Spacer()
                    Text(formatTime(focusTotal + (mode == .focus ? currentElapsed : 0)))
                        .monospacedDigit()
                }

                HStack {
                    Text("休憩")
                    Spacer()
                    Text(formatTime(restTotal + (mode == .rest ? currentElapsed : 0)))
                        .monospacedDigit()
                }
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
        }
        .padding()
    }

    private func switchMode(at now: Date) {
        let elapsed = now.timeIntervalSince(startDate)

        // ① いまのモードの時間を合計に足す
        if mode == .focus {
            focusTotal += elapsed
            mode = .rest
        } else {
            restTotal += elapsed
            mode = .focus
        }

        // ② 次のモードの開始時刻を更新
        startDate = now
    }

    private func formatTime(_ t: TimeInterval) -> String {
        let total = max(0, Int(t))
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60

        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }
    
}

