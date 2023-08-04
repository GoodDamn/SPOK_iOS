//
//  Notifications.swift
//  SPOK
//
//  Created by Cell on 26.07.2022.
//

import UserNotifications;

class EveryDayNotification{

    func showNotification()->UNNotificationRequest{
        let titles = ["SPOK as a lifestyle ✌",
            "At home or on the way to work? 🏠",
            "Light your inner fire! 🔥",
            "Long time no see! 👀"];
        let bodies = ["Little bits of text for big achievements. Especially for you.",
            "Take just two minutes to learn something new about your life",
            "This life was made for you. Begin to conquer the heights and go beyond what is possible.",
            "Many interesting and useful topics await you. Open up new horizons."];
        
        let index = Int.random(in: 0...3);
        
        
        let notificaitonContent = UNMutableNotificationContent();
        notificaitonContent.body = bodies[index];
        notificaitonContent.title = titles[index];
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15.0, repeats: false);
        
        let request = UNNotificationRequest(identifier: "everyDay", content: notificaitonContent, trigger: trigger);
        
        return request;
    }
    
}
