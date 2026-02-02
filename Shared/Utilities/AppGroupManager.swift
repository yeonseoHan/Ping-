//
//  AppGroupManager.swift
//  Ping!
//
//  Created by Yeonseo Han on 2/2/26.
//

import Foundation
// Shared/Utilities/AppGroupManager.swift


class AppGroupManager {
    static let shared = AppGroupManager()
    
    // ⚠️ 여기를 본인이 만든 App Group ID로 변경!
    private let groupIdentifier = "group.com.kristenHan.ping"
    
    private init() {}
    
    var sharedUserDefaults: UserDefaults? {
        UserDefaults(suiteName: groupIdentifier)
    }
    
    // MARK: - 상수
    struct Keys {
        static let currentFriendId = "currentFriendId"
        static let currentFriendName = "currentFriendName"
        static let currentEmoji = "currentEmoji"
        static let lastReceivedTime = "lastReceivedTime"
        static let showInLiveActivity = "showInLiveActivity" // 설정
    }
    
    // MARK: - 현재 표시 중인 Ping 저장/로드
    
    func saveCurrentPing(friendId: String, friendName: String, emoji: String) {
        guard let defaults = sharedUserDefaults else {
            print("❌ SharedUserDefaults 접근 실패")
            return
        }
        
        defaults.set(friendId, forKey: Keys.currentFriendId)
        defaults.set(friendName, forKey: Keys.currentFriendName)
        defaults.set(emoji, forKey: Keys.currentEmoji)
        defaults.set(Date().timeIntervalSince1970, forKey: Keys.lastReceivedTime)
        
        print("✅ 현재 Ping 저장: \(friendName) - \(emoji)")
    }
    
    func loadCurrentPing() -> (friendId: String, friendName: String, emoji: String, timestamp: Date)? {
        guard let defaults = sharedUserDefaults,
              let friendId = defaults.string(forKey: Keys.currentFriendId),
              let friendName = defaults.string(forKey: Keys.currentFriendName),
              let emoji = defaults.string(forKey: Keys.currentEmoji),
              let timestampInterval = defaults.object(forKey: Keys.lastReceivedTime) as? TimeInterval else {
            print("⚠️ 저장된 Ping 없음")
            return nil
        }
        
        let timestamp = Date(timeIntervalSince1970: timestampInterval)
        print("✅ 현재 Ping 로드: \(friendName) - \(emoji)")
        
        return (friendId, friendName, emoji, timestamp)
    }
    
    // MARK: - 설정 관리
    
    func setShowInLiveActivity(_ show: Bool) {
        sharedUserDefaults?.set(show, forKey: Keys.showInLiveActivity)
        print("✅ Live Activity 설정: \(show)")
    }
    
    func shouldShowInLiveActivity() -> Bool {
        // 기본값은 true (지속적으로 표시)
        return sharedUserDefaults?.object(forKey: Keys.showInLiveActivity) as? Bool ?? true
    }
    
    // MARK: - 데이터 초기화
    
    func clearCurrentPing() {
        guard let defaults = sharedUserDefaults else { return }
        
        defaults.removeObject(forKey: Keys.currentFriendId)
        defaults.removeObject(forKey: Keys.currentFriendName)
        defaults.removeObject(forKey: Keys.currentEmoji)
        defaults.removeObject(forKey: Keys.lastReceivedTime)
        
        print("✅ 현재 Ping 삭제")
    }
}
