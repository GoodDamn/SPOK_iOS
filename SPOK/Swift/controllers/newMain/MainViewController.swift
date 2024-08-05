//
//  MainViewController.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit
import Network

final class MainViewController
    : UIViewController {
    
    private let TAG = "MainViewController:"
    
    public static var mWidth: CGFloat = 0
    public static var mHeight: CGFloat = 0
    
    public static var mIsConnected = false
    public static var mIsPremiumUser = false
    public static var mCanPay = false
    public static var mDoAppleCheck = true
    
    public static var mBuildNumber = -1
    public static var mBuildNumberOld = -2
    
    public static var mCardSizeB: CGSize!
    public static var mCardSizeM: CGSize!
    public static var mCardTextSizeB: CardTextSize!
    public static var mCardTextSizeM: CardTextSize!
    
    private let mPremiumService =
        PremiumService()
    
    private var mProtectService: AppleProtectService? =
        AppleProtectService()
    
    private var mCurrentIndex = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor
            .background()
        
        MainViewController.mWidth = view.width()
        MainViewController.mHeight = view.height()
        
        checkApple { [weak self]
            appleChecks in
            
            DispatchQueue.ui {
                self?.superUpdateAppleCheck()
            }
            
            if appleChecks {
                MainViewController.mIsPremiumUser = true
                DispatchQueue.ui {
                    self?.superUpdatePremium()
                }
                return
            }
            self?.checkSub()
        }
        
        let mScreen = UIScreen
            .main
            .bounds
            .size
        
        let w = mScreen.width
        
        let wb = w * 0.847
        let wm = w * 0.403
        
        MainViewController.mCardSizeB = CGSize(
            width: wb,
            height: w * 0.5
        )
        
        MainViewController.mCardSizeM = CGSize(
            width: wm,
            height: w * 0.503
        )
        
        MainViewController.mCardTextSizeB = CardTextSize(
            title: 0.063 * wb,
            desc: 0.037 * wb
        )
        
        MainViewController.mCardTextSizeM = CardTextSize(
            title: 0.12 * wm,
            desc: 0.066 * wm // 0.066
        )
        
        if let buildNum = Bundle
            .main
            .infoDictionary?["CFBundleVersion"]
            as? String {
            
            let buildNumber = Int(buildNum) ?? -1
            
            MainViewController
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
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            [weak self] path in
            self?.networkUpdate(path)
        }
        monitor.start(
            queue: DispatchQueue(
                label: "Network"
            )
        )
        
        if !UserDefaults.isIntroCompleted() {
            UIApplication
                .shared
                .registerForRemoteNotifications()
            Log.d("Time for intro!")
            
            showSplash(
                msg: "готовим что-то\n уникальное..."
            ) { [weak self] in
                return IntroSleepRootController()
            }
            
            // Copying first content Kit to
            // Cache directory
            
            cacheFirstContentKit()
            
            return
        }
        
        Log.d("Time for content!")
        
        showSplash(
            msg: "отправляемся\nв мир снов..."
        ) { [weak self] in
            return MainContentViewController()
        }
        
    }
    
    public func pusht(
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
    
    public func push(
        _ c: StackViewController,
        animDuration: TimeInterval,
        animate: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        appendController(c)
       
        UIView.animate(
            withDuration: animDuration,
            animations: animate
        ) { [weak self] b in
            c.transitionEnd()
            completion?(b)
        }
    }
    
    public func pop(
        duration: TimeInterval? = nil,
        animate: (()->Void)? = nil
    ) {
        pop(
            at: mCurrentIndex - 1,
            duration: duration,
            animate: animate
        )
    }
    
    public func pop(
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

extension MainViewController {
    
    public final func superUpdatePremium() {
        for c in children {
            (c as? StackViewController)?
                .updatePremium()
        }
    }
    
    public final func superUpdateAppleCheck() {
        for c in children {
            (c as? StackViewController)?
                .updateAppleCheck()
        }
    }
    
    
    private func cacheFirstContentKit() {
        
        let fm = FileManager.default
        
        guard let cache = fm.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            return
        }
        
        guard let resPath = Bundle
            .main
            .resourcePath else {
            return
        }
        
        guard let content = try? fm.contentsOfDirectory(
            atPath: resPath
        ) else {
            return
        }
        
        let dirColl = cache.append(
            StorageApp.mDirCollectionSleep
        )
        
        let dirPrev = cache.append(
            StorageApp.mDirPreviews
        )
        
        let dirCont = cache.append(
            StorageApp.mDirContent
        )
        
        fm.createDirWithNullTime(
            dir: dirColl
        )
        
        fm.createDirWithNullTime(
            dir: dirPrev
        )
        
        fm.createDirWithNullTime(
            dir: dirCont
        )
        
        let bundle = Bundle.main.bundleURL
        
        for fileName in content {
            if fileName.contains(".skc") {
                fm.copyItemWithNullTime(
                    at: bundle.append(
                        fileName
                    ),
                    to: dirCont.append(
                        fileName
                    )
                )
                continue
            }
            
            if fileName.contains(".scs") {
                fm.copyItemWithNullTime(
                    at: bundle.append(
                        fileName
                    ),
                    to: dirColl.append(
                        fileName
                    )
                )
                continue
            }
            
            if fileName.contains(".spc") {
                fm.copyItemWithNullTime(
                    at: bundle.append(
                        fileName
                    ),
                    to: dirPrev.append(
                        fileName
                    )
                )
                continue
            }
            
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
    
    private func checkApple(
        completion: ((Bool)-> Void)? = nil
    ) {
        Log.d(
            AppDelegate.self,
            "time for update protect:",
            mProtectService?
                .isTimeForUpdateState()
        )
                
        if !(mProtectService?
            .isTimeForUpdateState() ?? false) {
            
            let appleChecks = mProtectService?
                .doesAppleCheck() ?? true
            
            MainViewController.mDoAppleCheck =
                appleChecks
            
            completion?(
                appleChecks
            )
            
            mProtectService = nil
            return
        }
        
        mProtectService!.updateAppleState {
            [weak self] hasApple in
            MainViewController.mDoAppleCheck = hasApple
            completion?(
                hasApple
            )
            self?.mProtectService = nil
        }
    }
    
    private func checkSub() {
        Log.d(
            MainViewController.self,
            "checkSub:"
        )
        mPremiumService
            .mOnCheckPremium = {[weak self]
                withSub in
                
                Log.d(
                    MainViewController.self,
                    "checkSub: onCheckPremium"
                )
                
                MainViewController.mIsPremiumUser = withSub
                MainViewController.mCanPay = true
                
                if withSub {
                    DispatchQueue.ui {
                        self?.superUpdatePremium()
                    }
                }
                
            }
        
        DatabaseUtils.apiKey(
            Keys.API_YOO
        ) { [weak self] apikey in
            Keys.AUTH = apikey
            self?.mPremiumService
                .start()
        }
        
        let def = UserDefaults
            .standard
        
        guard let userID = AuthUtils
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
    
    
    // Network dispatch queue
    private func networkUpdate(
        _ path: NWPath
    ) {
        MainViewController.mIsConnected =
            path.status == .satisfied
        Log.d(
            "MainViewController: networkUpdate:",
            MainViewController.mIsConnected
        )
        
    }
    
}
