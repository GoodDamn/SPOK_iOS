//
//  UNUserNotificationCenter.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation
import UserNotifications.UNUserNotificationCenter

extension UNUserNotificationCenter {
    
    static func settings(
        completion: @escaping (
            (UNNotificationSettings) -> Void
        )
    ) {
        UNUserNotificationCenter.current().getNotificationSettings(
            completionHandler: completion
        )
    }
    
    static func request(
        completion: ((Bool) -> Void)? = nil
    ) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [
                .alert,
                .badge,
                .sound
            ]
        ) { granted, error in
            
            if error != nil {
                Log.d(
                    UNUserNotificationCenter.self,
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
