//
//  MinimalLiveActivity.swift
//  PingWidget
//

import ActivityKit
import WidgetKit
import SwiftUI

// 테스트용 최소 Live Activity
struct MinimalLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PingAttributes.self) { context in
            // 가장 단순한 View
            HStack {
                Text(context.state.emoji)
                    .font(.largeTitle)
                Text(context.state.friendName)
                    .font(.headline)
            }
            .padding()
            .activityBackgroundTint(.blue)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.emoji)
                }
            } compactLeading: {
                Text(context.state.emoji)
            } compactTrailing: {
                Text(context.state.friendName)
            } minimal: {
                Text(context.state.emoji)
            }
        }
    }
}
