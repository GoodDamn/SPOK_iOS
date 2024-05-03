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
    
    private static let TAG = "MainViewController:"
    
    public static var mIsConnected = false
    public static var mIsPremiumUser = false
    
    public static var mBuildNumber = -1
    public static var mBuildNumberOld = -2
    
    public static var mCardSizeB: CGSize!
    public static var mCardSizeM: CGSize!
    public static var mCardTextSizeB: CardTextSize!
    public static var mCardTextSizeM: CardTextSize!
    
    private let mPremiumService =
        PremiumService()
    
    private var mControllers: [StackViewController] = []
    
    private var mCurrentIndex = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor
            .background()
        
        checkSub()
        
        let mScreen = UIScreen
            .main
            .bounds
            .size
        
        let w = mScreen.width
        
        let def = UserDefaults
            .standard
        
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
        
        Log.d(TAG, "CARD_TEXT_SIZES:",
              "B:", MainViewController.mCardTextSizeB,
              "M:", MainViewController.mCardTextSizeM
        )
        
        if let buildNum = Bundle
            .main
            .infoDictionary?["CFBundleVersion"]
            as? String {
            
            let buildNumber = Int(buildNum) ?? -1
            
            MainViewController
                .mBuildNumber = buildNumber
            
            let oldbn = def.integer(
                forKey: Keys.OLD_BUILD_NUMBER
            )
            
            if buildNumber != oldbn  {
                def.removeObject(
                    forKey: Keys.ID_NEWS
                )
                
                def.setValue(
                    buildNumber,
                    forKey: Keys.OLD_BUILD_NUMBER
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
        
        if !def.bool(
            forKey: Keys.COMPLETE_INTRO
        ) {
            UIApplication
                .shared
                .registerForRemoteNotifications()
            Log.d("Time for intro!")
            
            showSplash(
                msg: "готовим что-то\n уникальное..."
            ) {
                return
                    IntroSleepRootController()
            }
            
            // Copying first content Kit to
            // Cache directory
            
            cacheFirstContentKit()
            
            return
        }
        
        Log.d("Time for content!")
        
        showSplash(
            msg: "отправляемся\nв мир снов..."
        ) {
            return
                MainContentViewController()
        }
        
    }
    
    public func pusht(
        _ c: StackViewController,
        animDuration: TimeInterval,
        options: UIView.AnimationOptions,
        completion: ((Bool) -> Void)?
    ) {
        let prev = mControllers.last
        
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
        ) { b in
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
        ) { _ in
            self.removeController(
                at: at
            )
        }
    }
    
    private func removeController(
        at: Int
    ) {
        let c = mControllers[at]
        c.view.removeFromSuperview()
        c.removeFromParent()
        mControllers.remove(at: at)
    }
    
    private func appendController(
        _ c: StackViewController
    ) {
        mControllers.append(c)
        addChild(c)
        view.addSubview(c.view)
        mCurrentIndex += 1
    }
    
}

extension MainViewController {
    
    public final func superUpdatePremium() {
        for c in mControllers {
            c.updatePremium()
        }
    }
    
    public final func superUpdateState() {
        for c in mControllers {
            c.updateState()
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
        
        try? fm.createDirectory(
            at: dirColl,
            withIntermediateDirectories: true
        )
        
        try? fm.createDirectory(
            at: dirPrev,
            withIntermediateDirectories: false
        )
        
        try? fm.createDirectory(
            at: dirCont,
            withIntermediateDirectories: false
        )
        
        let bundle = Bundle.main.bundleURL
        
        for fileName in content {
            if fileName.contains(".skc") {
                try? fm.copyItem(
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
                try? fm.copyItem(
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
                try? fm.copyItem(
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
    
    private func checkSub() {
        
        mPremiumService
            .mOnCheckPremium = {[weak self]
                withSub in
                
                MainViewController.mIsPremiumUser = withSub
                
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
