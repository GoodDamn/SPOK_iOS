//
//  AppDelegate.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit;
//import FBSDKCoreKit;
import FirebaseCore;
import FirebaseDatabase;
import FirebaseMessaging;
import RevenueCat;
import AuthenticationServices;
import UserNotifications;

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?;
    
    var messaging: Messaging? = nil;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("APP::application launching with options")
        
        //Networking.shared.startMonitoring();
        FirebaseApp.configure();
        
        //Purchases.logLevel = .debug;
        //Purchases.configure(withAPIKey: "appl_AgtJbTousDKpVjwtUxnAkFGaNfN");
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:launchOptions);
        /*let center = UNUserNotificationCenter.current();
         center.delegate = self;
         
         PushNotifications.notify(notification: "event", center: center);
         PushNotifications.notify(notification: "new", center: center);*/
        
        let center = UNUserNotificationCenter.current();
        center.delegate = self;
        center.requestAuthorization(options: [.alert, .badge, .sound],completionHandler: { _, _ in});
        
        application.registerForRemoteNotifications();
        
        messaging = Messaging.messaging();
        
        messaging?.delegate = self;
        messaging?.isAutoInitEnabled = true;
        
        return true;
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        /*ApplicationDelegate.shared.application(
         app,
         open: url,
         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
         annotation: options[UIApplication.OpenURLOptionsKey.annotation]);*/
        return true;
        
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        messaging?.apnsToken = deviceToken;
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APP::FAIL_REGISTER_REMOTE_NOTIFICATION:",error);
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("APP:messaging(didReceiveRegistrationToken): ",fcmToken?.description);
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(self, "The notification is to be presented", notification.request.identifier);
        completionHandler([.alert]);
    }
}
