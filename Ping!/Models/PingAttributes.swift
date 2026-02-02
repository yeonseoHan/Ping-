//
//  PingAttributes.swift
//  Ping!
//
//  Created by Yeonseo Han on 2/2/26.
//

// Ping/Models/PingAttributes.swift

import ActivityKit
import Foundation

struct PingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        var friendName: String
        var emoji: String
        var timestamp: Date
        
        var opacity: Double {
            let elapsed = Date().timeIntervalSince(timestamp)
            let twoHours: TimeInterval = 2 * 60 * 60
            return min(elapsed / twoHours, 1.0)
        }
        
        var saturation: Double {
            return 1.0 - opacity
        }
        
        var timeAgoText: String {
            let seconds = Int(Date().timeIntervalSince(timestamp))
            
            if seconds < 60 {
                return "just now"
            } else if seconds < 3600 {
                let minutes = seconds / 60
                return "\(minutes)m ago"
            } else {
                let hours = seconds / 3600
                return "\(hours)h ago"
            }
        }
    }
    
    var friendId: String
}
