//
//  NotificationUtils.swift
//  SPOK
//
//  Created by GoodDamn on 11/02/2024.
//

import Foundation
import UserNotifications.UNUserNotificationCenter

class NotificationUtils {
    
    private static let TAG = "Notification"
    
    public static func settings(
        completion: @escaping (
            (UNNotificationSettings) -> Void
        )
    ) {
        let center = UNUserNotificationCenter
            .current()
        
        center.getNotificationSettings(
            completionHandler: completion
        )
    }
    
    public static func request(
        completion: ((Bool) -> Void)? = nil
    ) {
        let center = UNUserNotificationCenter
            .current()
        center.requestAuthorization(
            options: [
                .alert,
                .badge,
                .sound
            ]
        ) { granted, error in
            
            if error != nil {
                print(
                    TAG,
                    "REQUEST_ERROR:",
                    error!
                        .localizedDescription
                )
                return
            }
            
            completion?(granted)
        }
        
    }
    
}
