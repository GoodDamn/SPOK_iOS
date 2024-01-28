//
//  MainViewController.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

class MainViewController
: UIViewController {
    
    public static var mCardSizeB: CGSize!
    public static var mCardSizeM: CGSize!
    public static var mCardTextSizeB: CardTextSize!
    public static var mCardTextSizeM: CardTextSize!
    
    private var mControllers: [UIViewController] = []
    
    private var mCurrentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
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
        
        print("MainViewController::", "CARD_TEXT_SIZES:",
              "B:", MainViewController.mCardTextSizeB,
              "M:", MainViewController.mCardTextSizeM
        )
        
        /*
         
         let buildNumber = Int(Bundle
         .main
         .infoDictionary?["CFBundleVersion"]
         as? String ?? "25"
         ) ?? 25;
         
         print(self.tag, "BUILD NUMBER:",buildNumber);
         
         
         let monitor = NWPathMonitor();
         monitor.pathUpdateHandler = {
         path in
         self.isConnected = path.status == .satisfied;
         if !self.isConnected {
         DispatchQueue.main.async {
         self.heightSnackbar.constant = 24;
         UIView.animate(withDuration: 0.23, animations: {
         self.view.layoutIfNeeded();
         });
         }
         return;
         }
         
         }
         
         monitor.start(queue: DispatchQueue(label:"Network")
         );*/
        
        
        let userDefaults = UserDefaults();
        
        if !userDefaults.bool(forKey: "intro") {
            print("Time for intro!")
            let c = IntroSleepRootController()
            c.view.alpha = 0
            push(
                c,
                animDuration: 1.5
            ) {
                c.view.alpha = 1.0
            }
            
            
            return;
        }
        
        print("Intro is completed");
        
        let splash = SplashViewController()
        splash.view.alpha = 0
        push(
            splash,
            animDuration: 1.0
        ) {
            splash.view.alpha = 1.0
        }
        
        
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + 2.5
            ) {
                let controller =  MainContentViewController()
                
                self.pusht(
                    controller,
                    animDuration: 1.0,
                    options: [
                        .transitionCrossDissolve
                    ]
                ) { b in
                    self.pop(at: 0)
                }
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
            options: options,
            completion: completion
        )
    }
    
    public func push(
        _ c: StackViewController,
        animDuration: TimeInterval,
        animate: @escaping () -> Void
    ) {
        mCurrentIndex += 1
        appendController(c)
        
        UIView.animate(
            withDuration: animDuration,
            animations: animate
        )
    }
    
    public func pop(
        duration: TimeInterval? = nil,
        animate: (()->Void)? = nil
    ) {
        pop(
            at: mCurrentIndex,
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
    }
        
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
