// Ping/Views/ContentView.swift

import SwiftUI
import WidgetKit
import ActivityKit

struct ContentView: View {
    @State private var selectedEmoji = "🔥"
    @State private var friendName = "Alice"
    @State private var isActivityActive = false
    
    let emojis = ["🔥", "❤️", "👍", "😂", "🎉", "👋", "💯", "✨"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // 헤더
                    VStack(spacing: 8) {
                        Text("Ping!")
                            .font(.system(size: 44, weight: .bold))
                        Text("Live Activity Test")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // 이모지 선택
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Emoji")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(emojis, id: \.self) { emoji in
                                    Button(action: {
                                        selectedEmoji = emoji
                                    }) {
                                        Text(emoji)
                                            .font(.system(size: 50))
                                            .frame(width: 80, height: 80)
                                            .background(
                                                Circle()
                                                    .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedEmoji == emoji ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 친구 이름 입력
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Friend Name")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextField("Enter name", text: $friendName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }
                    
                    // 액션 버튼들
                    VStack(spacing: 16) {
                        // Ping 전송
                        Button(action: sendPing) {
                            HStack {
                                Text(selectedEmoji)
                                    .font(.title)
                                Text("Send Ping")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        
                        // Activity 종료
                        Button(action: endActivity) {
                            Text("End Live Activity")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
                        // 상태 표시
                        HStack {
                            Circle()
                                .fill(isActivityActive ? Color.green : Color.gray)
                                .frame(width: 8, height: 8)
                            Text(isActivityActive ? "Live Activity Active" : "No Active Activity")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                    
                    // 테스트 버튼들
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Time Travel (Debug)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Button(action: { testWithDelay(minutes: 0) }) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("Now (선명)")
                                    Spacer()
                                    Text("100% saturation")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .foregroundColor(.primary)
                            
                            Button(action: { testWithDelay(minutes: 30) }) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("30분 전")
                                    Spacer()
                                    Text("75% saturation")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .foregroundColor(.primary)
                            
                            Button(action: { testWithDelay(minutes: 60) }) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("1시간 전")
                                    Spacer()
                                    Text("50% saturation")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .foregroundColor(.primary)
                            
                            Button(action: { testWithDelay(minutes: 120) }) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("2시간 전 (회색)")
                                    Spacer()
                                    Text("0% saturation")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .foregroundColor(.primary)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            checkActivityStatus()
        }
    }
    
    // MARK: - Actions
    
    private func sendPing() {
        print("🔵 sendPing 시작")
        print("🔵 shouldShowInLiveActivity: \(AppGroupManager.shared.shouldShowInLiveActivity())")
        
        if #available(iOS 16.2, *) {
            Task { @MainActor in
                print("🔵 Activity 시작 호출")
                LiveActivityService.shared.startOrUpdateActivity(
                    friendId: "test_friend_123",
                    friendName: friendName,
                    emoji: selectedEmoji
                )
                isActivityActive = true
                print("🔵 isActivityActive: true")
            }
        } else {
            print("🔴 iOS 버전 부족")
        }
    }
    
    private func endActivity() {
        if #available(iOS 16.2, *) {
            Task { @MainActor in
                LiveActivityService.shared.endActivity()
                isActivityActive = false
            }
        }
    }
    
    private func testWithDelay(minutes: Int) {
        let testTimestamp = Date().addingTimeInterval(-Double(minutes * 60))
        
        if #available(iOS 16.2, *) {
            Task { @MainActor in
                // SharedUserDefaults에 과거 시간으로 저장
                AppGroupManager.shared.saveCurrentPing(
                    friendId: "test_friend_123",
                    friendName: friendName,
                    emoji: selectedEmoji
                )
                
                // Activity 시작하되 timestamp 조작 (테스트용)
                LiveActivityService.shared.startOrUpdateActivity(
                    friendId: "test_friend_123",
                    friendName: friendName,
                    emoji: selectedEmoji
                )
                
                isActivityActive = true
            }
        }
    }
    
    private func checkActivityStatus() {
        if #available(iOS 16.2, *) {
            isActivityActive = !Activity<PingAttributes>.activities.isEmpty
        }
    }
}

#Preview {
    ContentView()
}
