//
//  AppDelegate.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit;
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate
    : UIResponder,
      UIApplicationDelegate {
    
    public static var mDoAppleCheck = true
    
    private var mProtectService:
        AppleProtectService? =
        AppleProtectService()
    
    var window: UIWindow?;
    
    var messaging: Messaging? = nil;
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()

        messaging = Messaging.messaging()
        
        messaging?.delegate = self
        messaging?.isAutoInitEnabled = true
        
        Log.d(
            AppDelegate.self,
            "time for update protect:",
            mProtectService?
                .isTimeForUpdateState()
        )
        
        if !(mProtectService?
            .isTimeForUpdateState() ?? false) {
            return true
        }
        
        mProtectService!.updateAppleState {
            [weak self] hasApple in
            AppDelegate.mDoAppleCheck = hasApple
            self?.mProtectService = nil
        }
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Log.d(
            AppDelegate.self,
            "DEVICE_TOKEN:",
            deviceToken,
            messaging
        )
        messaging?.apnsToken = deviceToken;
    }
    
    func application(_ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Log.d(
            AppDelegate.self,
            "FAIL_REGISTER_REMOTE_NOTIFICATION:",
            error
        )
    }
    
}

extension AppDelegate
    : MessagingDelegate {
    
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        Log.d(
            AppDelegate.self,
            "messaging(didReceiveRegistrationToken): ",
            fcmToken?.description
        )
    }
    
}
