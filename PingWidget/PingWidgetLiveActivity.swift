//
//  PingWidgetLiveActivity.swift
//  PingWidget
//
//  Created by Yeonseo Han on 2/2/26.
//
// PingWidget/PingWidgetLiveActivity.swift

import ActivityKit
import WidgetKit
import SwiftUI

struct PingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PingAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded (확장 모드)
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 12) {
                        // 이모지 (메인)
                        EmojiView(
                            emoji: context.state.emoji,
                            saturation: context.state.saturation,
                            size: 80
                        )
                        
                        // 친구 이름
                        Text(context.state.friendName)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        // 시간
                        Text(context.state.timeAgoText)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.vertical, 16)
                }
                
            } compactLeading: {
                // Compact 왼쪽 (Dynamic Island 축소 모드)
                EmojiView(
                    emoji: context.state.emoji,
                    saturation: context.state.saturation,
                    size: 24
                )
                
            } compactTrailing: {
                // Compact 오른쪽
                Text(context.state.friendName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
            } minimal: {
                // Minimal (여러 Activity 동시 실행 시)
                EmojiView(
                    emoji: context.state.emoji,
                    saturation: context.state.saturation,
                    size: 20
                )
            }
            .contentMargins(.all, 8, for: .expanded)
        }
    }
}

// MARK: - 잠금화면 뷰

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<PingAttributes>
    
    var body: some View {
        HStack(spacing: 16) {
            // 왼쪽: 이모지 (글라스모피즘)
            GlassmorphicEmojiView(
                emoji: context.state.emoji,
                saturation: context.state.saturation
            )
            
            // 오른쪽: 텍스트 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.friendName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("sent you a ping!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(context.state.timeAgoText)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            GlassmorphicBackground(opacity: context.state.opacity)
        )
    }
}

// MARK: - 글라스모피즘 이모지 (바운스 애니메이션 포함)

struct GlassmorphicEmojiView: View {
    let emoji: String
    let saturation: Double
    
    @State private var bounce = false
    @State private var scale = false
    @State private var previousEmoji: String = ""
    
    var body: some View {
        ZStack {
            // 프리즘 효과 배경
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .purple.opacity(0.3),
                            .blue.opacity(0.3),
                            .cyan.opacity(0.3),
                            .green.opacity(0.3),
                            .yellow.opacity(0.3),
                            .orange.opacity(0.3),
                            .red.opacity(0.3),
                            .purple.opacity(0.3)
                        ]),
                        center: .center
                    )
                )
                .blur(radius: 8)
                .frame(width: 70, height: 70)
                .opacity(saturation * 0.5)
            
            // 글라스 레이어
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 65, height: 65)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.5),
                                    .white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            // 이모지
            Text(emoji)
                .font(.system(size: 40))
                .colorMultiply(Color(white: 1.0, opacity: saturation))
                .saturation(saturation)
                .scaleEffect(scale ? 1.2 : 1.0)
                .offset(y: bounce ? -8 : 0)
        }
        .onChange(of: emoji) { oldValue, newValue in
            if !previousEmoji.isEmpty && previousEmoji != newValue {
                // 새 이모지면 바운스 애니메이션
                triggerBounce()
            }
            previousEmoji = newValue
        }
        .onAppear {
            previousEmoji = emoji
        }
    }
    
    private func triggerBounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            bounce = true
            scale = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bounce = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.2)) {
                scale = false
            }
        }
    }
}

// MARK: - 단순 이모지 뷰 (Dynamic Island용)

struct EmojiView: View {
    let emoji: String
    let saturation: Double
    let size: CGFloat
    
    @State private var bounce = false
    @State private var scale = false
    @State private var previousEmoji: String = ""
    
    var body: some View {
        Text(emoji)
            .font(.system(size: size))
            .colorMultiply(Color(white: 1.0, opacity: saturation))
            .saturation(saturation)
            .scaleEffect(scale ? 1.3 : 1.0)
            .offset(y: bounce ? -4 : 0)
            .onChange(of: emoji) { oldValue, newValue in
                if !previousEmoji.isEmpty && previousEmoji != newValue {
                    triggerBounce()
                }
                previousEmoji = newValue
            }
            .onAppear {
                previousEmoji = emoji
            }
    }
    
    private func triggerBounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            bounce = true
            scale = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bounce = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.2)) {
                scale = false
            }
        }
    }
}

// MARK: - 글라스모피즘 배경

struct GlassmorphicBackground: View {
    let opacity: Double
    
    var body: some View {
        ZStack {
            // 베이스 글라스
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
            
            // 프리즘 그라디언트 오버레이
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            .purple.opacity(0.2 * (1 - opacity)),
                            .blue.opacity(0.15 * (1 - opacity)),
                            .cyan.opacity(0.1 * (1 - opacity))
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 가장자리 프리즘 빛
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .purple.opacity(0.4 * (1 - opacity)),
                            .blue.opacity(0.4 * (1 - opacity)),
                            .cyan.opacity(0.4 * (1 - opacity)),
                            .green.opacity(0.4 * (1 - opacity)),
                            .yellow.opacity(0.4 * (1 - opacity)),
                            .orange.opacity(0.4 * (1 - opacity)),
                            .red.opacity(0.4 * (1 - opacity)),
                            .purple.opacity(0.4 * (1 - opacity))
                        ]),
                        center: .center,
                        angle: .degrees(0)
                    ),
                    lineWidth: 2
                )
                .blur(radius: 2)
            
            // 하이라이트 (유리 느낌)
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.3 * (1 - opacity)),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
        }
    }
}

// MARK: - Preview

#Preview("Live Activity", as: .content, using: PingAttributes(friendId: "user123")) {
    PingWidgetLiveActivity()
} contentStates: {
    // 방금 받음 (선명)
    PingAttributes.ContentState(
        friendName: "Alice",
        emoji: "🔥",
        timestamp: Date()
    )
    
    // 30분 후 (약간 흐릿)
    PingAttributes.ContentState(
        friendName: "Alice",
        emoji: "🔥",
        timestamp: Date().addingTimeInterval(-30 * 60)
    )
    
    // 1시간 후 (더 흐릿)
    PingAttributes.ContentState(
        friendName: "Alice",
        emoji: "🔥",
        timestamp: Date().addingTimeInterval(-60 * 60)
    )
    
    // 2시간 후 (회색)
    PingAttributes.ContentState(
        friendName: "Alice",
        emoji: "🔥",
        timestamp: Date().addingTimeInterval(-120 * 60)
    )
}
