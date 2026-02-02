import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var friendName = "Alex"
    @State private var emoji = "💖"

    var body: some View {
        VStack(spacing: 20) {
            Text("Ping Test Panel")
                .font(.headline)

            Button("Send Ping 💖") {
                sendPing(emoji: "💖")
            }
            .buttonStyle(.borderedProminent)

            Button("Send Old Ping 💔") {
                sendPing(emoji: "💔", oldPing: true)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    // MARK: Ping 시뮬레이션
    func sendPing(emoji: String, oldPing: Bool = false) {
        let defaults = UserDefaults(suiteName: "group.com.yourname.ping")
        defaults?.set(friendName, forKey: "friendName")
        defaults?.set(emoji, forKey: "lastEmoji")

        let date = oldPing
            ? Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
            : Date.now
        defaults?.set(date, forKey: "lastReceivedAt")

        // 위젯 즉시 갱신
        WidgetCenter.shared.reloadAllTimelines()
    }
}
