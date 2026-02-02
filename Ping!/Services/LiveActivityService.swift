//
//  LiveActivityService.swift
//  Ping!
//
//  Created by Yeonseo Han on 2/2/26.
//

// Ping/Services/LiveActivityService.swift
// Ping/Services/LiveActivityService.swift

import ActivityKit
import Foundation
import WidgetKit

@available(iOS 16.2, *)
final class LiveActivityService: Sendable {
    
    static let shared = LiveActivityService()
    
    private init() {}
    
    @MainActor
    private var currentActivity: Activity<PingAttributes>? = nil
    
    @MainActor
    private var updateTimer: Timer? = nil
    
    // MARK: - Public Methods
    
    @MainActor
    func startOrUpdateActivity(friendId: String, friendName: String, emoji: String) {
        AppGroupManager.shared.saveCurrentPing(
            friendId: friendId,
            friendName: friendName,
            emoji: emoji
        )
        
        guard AppGroupManager.shared.shouldShowInLiveActivity() else {
            return
        }
        
        if let activity = currentActivity {
            Task {
                await updateExistingActivity(friendName: friendName, emoji: emoji)
            }
        } else {
            createNewActivity(friendId: friendId, friendName: friendName, emoji: emoji)
        }
        
        startUpdateTimer()
    }
    
    @MainActor
    func endActivity() {
        guard let activity = currentActivity else {
            return
        }
        
        currentActivity = nil
        stopUpdateTimer()
        
        Task {
            let finalState = activity.content.state
            await activity.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .immediate
            )
        }
    }
    
    @MainActor
    func endAllActivities() {
        currentActivity = nil
        stopUpdateTimer()
        
        Task {
            for activity in Activity<PingAttributes>.activities {
                let finalState = activity.content.state
                await activity.end(
                    ActivityContent(state: finalState, staleDate: nil),
                    dismissalPolicy: .immediate
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func createNewActivity(friendId: String, friendName: String, emoji: String) {
        let attributes = PingAttributes(friendId: friendId)
        let contentState = PingAttributes.ContentState(
            friendName: friendName,
            emoji: emoji,
            timestamp: Date()
        )
        
        do {
            let activity = try Activity<PingAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: contentState, staleDate: nil),
                pushType: nil
            )
            
            currentActivity = activity
            
        } catch {
            // 에러 무시
        }
    }
    
    @MainActor
    private func updateExistingActivity(friendName: String, emoji: String) async {
        guard let activity = currentActivity else { return }
        
        let newState = PingAttributes.ContentState(
            friendName: friendName,
            emoji: emoji,
            timestamp: Date()
        )
        
        await activity.update(
            ActivityContent(state: newState, staleDate: nil)
        )
    }
    
    @MainActor
    private func startUpdateTimer() {
        stopUpdateTimer()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.updateActivityOpacity()
            }
        }
    }
    
    @MainActor
    private func stopUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    @MainActor
    private func updateActivityOpacity() async {
        guard let activity = currentActivity else { return }
        
        let currentState = activity.content.state
        let elapsed = Date().timeIntervalSince(currentState.timestamp)
        let twoHours: TimeInterval = 2 * 60 * 60
        
        if elapsed >= twoHours {
            endActivity()
            return
        }
        
        await activity.update(
            ActivityContent(state: currentState, staleDate: nil)
        )
    }
}

