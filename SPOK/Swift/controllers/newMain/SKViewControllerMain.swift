//
//  MainViewController.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

final class SKViewControllerMain
    : UIViewController {
        
    static var mWidth: CGFloat = 0
    static var mHeight: CGFloat = 0
    
    static var mIsConnected = false
    static var mIsPremiumUser = false
    static var mCanPay = false
    static var mDoAppleCheck = true
    
    static var mBuildNumber = -1
    static var mBuildNumberOld = -2
    
    static var mCardSizeB: CGSize!
    static var mCardSizeM: CGSize!
    static var mCardTextSizeB: CardTextSize!
    static var mCardTextSizeM: CardTextSize!
    
    private let mServicePremium = SKServicePremium()
    private let mServiceYookassa = SKServiceYooKassa()
    private let mServiceNetwork = SKServiceNetwork()
    private let mServiceServer = SKServiceServer()
    private let mServiceProtect = SKServiceAppleProtect()
    
    private var mCurrentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor
            .background()
        
        SKViewControllerMain.mWidth = view.width()
        SKViewControllerMain.mHeight = view.height()
        
        mServiceServer.onGetServerConfig = self
        mServiceProtect.onGetPiratedState = self
        mServicePremium.onGetPremiumStatus = self
        mServiceYookassa.onGetApiKey = self
        mServiceNetwork.delegate = self
        
        let mScreen = UIScreen
            .main
            .bounds
            .size
        
        let w = mScreen.width
        
        let wb = w * 0.847
        let wm = w * 0.403
        
        SKViewControllerMain.mCardSizeB = CGSize(
            width: wb,
            height: w * 0.5
        )
        
        SKViewControllerMain.mCardSizeM = CGSize(
            width: wm,
            height: w * 0.503
        )
        
        SKViewControllerMain.mCardTextSizeB = CardTextSize(
            title: 0.063 * wb,
            desc: 0.037 * wb
        )
        
        SKViewControllerMain.mCardTextSizeM = CardTextSize(
            title: 0.12 * wm,
            desc: 0.066 * wm // 0.066
        )
        
        if let buildNumber = Bundle
            .main
            .buildVersion() {
                        
            SKViewControllerMain
                .mBuildNumber = buildNumber
            
            let oldbn = UserDefaults
                .oldBuildNumber()
            
            if buildNumber != oldbn  {
                UserDefaults.main().removeObject(
                    forKey: Keys.ID_NEWS
                )
                
                UserDefaults.oldBuildNumber(
                    buildNumber
                )
            }
            
        }
        
        mServiceNetwork.listenNetwork(
            queue: DispatchQueue(
                label: "NETWORK"
            )
        )
        
        mServiceProtect.getPiratedStateAsync()
        
        if !UserDefaults.isIntroCompleted() {
            UIApplication
                .shared
                .registerForRemoteNotifications()
            Log.d("Time for intro!")
            
            showSplash(
                msg: "готовим что-то\n уникальное..."
            ) {
                return IntroSleepRootController()
            }
            return
        }
        
        Log.d("Time for content!")
        
        showSplash(
            msg: "отправляемся\nв мир снов..."
        ) {
            return MainContentViewController()
        }
        
    }
    
    func pusht(
        _ c: StackViewController,
        animDuration: TimeInterval,
        options: UIView.AnimationOptions,
        completion: ((Bool) -> Void)?
    ) {
        let prev = children.last
        
        appendController(c)
        
        UIView.transition(
            from: prev!.view,
            to: c.view,
            duration: 1.5,
            options: options
        ) { b in
            c.transitionEnd()
            completion?(b)
        }
    }
    
    func push(
        _ c: StackViewController,
        animDuration: TimeInterval,
        animate: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        appendController(c)
       
        UIView.animate(
            withDuration: animDuration,
            animations: animate
        ) { b in
            c.transitionEnd()
            completion?(b)
        }
    }
    
    func pop(
        duration: TimeInterval? = nil,
        animate: (()->Void)? = nil
    ) {
        pop(
            at: mCurrentIndex - 1,
            duration: duration,
            animate: animate
        )
    }
    
    func pop(
        at: Int,
        duration: TimeInterval? = nil,
        animate: (()->Void)? = nil
    ) {
        mCurrentIndex -= 1
        
        if animate == nil
            || duration == nil
        {
            removeController(
                at: at
            )
            return
        }
        
        UIView.animate(
            withDuration: duration!,
            animations: animate!
        ) { [weak self] _ in
            self?.removeController(
                at: at
            )
        }
    }
    
    private func removeController(
        at: Int
    ) {
        let c = children[at]
        c.view.removeFromSuperview()
        c.removeFromParent()
    }
    
    private func appendController(
        _ c: StackViewController
    ) {
        addChild(c)
        view.addSubview(c.view)
        mCurrentIndex += 1
    }
    
}

extension SKViewControllerMain {
    
    final func superUpdatePremium() {
        for c in children {
            (c as? StackViewController)?
                .updatePremium()
        }
    }
    
    final func superUpdateAppleCheck() {
        for c in children {
            (c as? StackViewController)?
                .updateAppleCheck()
        }
    }
    
    private func showSplash(
        msg: String,
        _ completion: @escaping () -> StackViewController
    ) {
        let splash = SplashViewController()
        splash.msgBottom = msg
        splash.view.alpha = 1
        push(
            splash,
            animDuration: 1.0
        ) {
            splash.view.alpha = 1.0
        }
        
        DispatchQueue.ui(
            wait: 3.0
        ) { [weak self] in
            
            guard let s = self else {
                return
            }
            
            s.pusht(
                completion(),
                animDuration: 1.0,
                options: [
                    .transitionCrossDissolve
                ]
            ) { b in
                s.pop(at: 0)
            }
        }
    }
}

extension SKViewControllerMain
: SKListenerOnGetPiratedState {
    
    func onGetPiratedState(
        isPirated: Bool
    ) {
        SKViewControllerMain.mDoAppleCheck = isPirated
        
        superUpdateAppleCheck()
        
        if isPirated {
            SKViewControllerMain.mIsPremiumUser = true
            superUpdatePremium()
            return
        }
        
        Log.d(
            SKViewControllerMain.self,
            "onGetPiratedState:"
        )
        
        mServiceYookassa.getApiKeyAsync()
        
        let def = UserDefaults.main()
        
        guard let userID = SKUtilsAuth
            .user()?
            .uid else {
            def.removeObject(
                forKey: Keys.USER_REF
            )
            return
        }
        
        def.setValue(
            userID,
            forKey: Keys.USER_REF
        )
    }
    
}

extension SKViewControllerMain
: SKListenerOnGetServerConfig {
    
    func onGetServerConfig(
        model: SKModelServerConfig
    ) {
        mServicePremium.getPremiumStatusAsync(
            serverTimeSec: model.serverTimeSec
        )
    }
    
}

extension SKViewControllerMain
: SKListenerOnGetPremiumStatus {
    
    func onGetPremiumStatus(
        hasPremium: Bool
    ) {
        Log.d(
            SKViewControllerMain.self,
            "onGetPremiumStatus:"
        )
        
        SKViewControllerMain.mIsPremiumUser = hasPremium
        SKViewControllerMain.mCanPay = true
        
        if hasPremium {
            DispatchQueue.ui { [weak self] in
                self?.superUpdatePremium()
            }
        }
    }
    
}

extension SKViewControllerMain
: SKListenerOnGetYooKassaApiKey {
    
    func onGetYooKassaApiKey(
        key: String
    ) {
        Keys.AUTH = key
        mServiceServer.getServerConfigAsync()
    }
    
}

extension SKViewControllerMain
: SKDelegateOnNetworkChanged {
    
    func onNetworkChanged(
        isConnected: Bool
    ) {
        SKViewControllerMain.mIsConnected =
            isConnected
            
        Log.d(
            "MainViewController: networkUpdate:",
            SKViewControllerMain.mIsConnected
        )
    }
    
}
