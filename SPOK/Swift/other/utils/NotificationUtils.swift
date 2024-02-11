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
    
    public static func setupDaily(
        center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    ) {
        center.requestAuthorization(
            options: [.sound, .alert, .badge]
        ) { granted, error in
            
            if let error = error {
                print(TAG, error)
                return;
            }
            
            if !granted{
                return
            }
            
            print(TAG, "Permission is granted");
            
            center.removeAllPendingNotificationRequests();
            
            let dailyContentSize:UInt8 = 4;
            
            var dateComponents = DateComponents();
            dateComponents.calendar = Calendar.current;
            
            let content = UNMutableNotificationContent();
            
            for day in 1...7 {
                
                var dd = UInt8.random(in: 1...dailyContentSize);
                
                content.title = Utils.getLocalizedString("edn\(dd)");
                content.body = Utils.getLocalizedString("ednb\(dd)");
                
                dateComponents.weekday = day;
                dateComponents.minute = 0
                dateComponents.hour = 7
                
                center.add(UNNotificationRequest(
                    identifier: ("SPOK7\(day)\(dd)"),
                    content: content,
                    trigger: UNCalendarNotificationTrigger(
                        dateMatching: dateComponents,
                        repeats: true)))
                
                dateComponents.hour = 18;
                
                dd = UInt8.random(in: 1...dailyContentSize);
                
                content.title = Utils.getLocalizedString("edn\(dd)");
                content.body = Utils.getLocalizedString("ednb\(dd)");
                
                center.add(UNNotificationRequest(
                    identifier: "SPOK18\(day)\(dd)",
                    content: content,
                    trigger: UNCalendarNotificationTrigger(
                        dateMatching: dateComponents,
                        repeats: true)))
                
            }
            
        }
        
    }
    
}
