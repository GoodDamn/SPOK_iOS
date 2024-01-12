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
    
    private var mControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overFullScreen
        
        view.backgroundColor = UIColor(
            named: "background"
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
        
        let sMain = UIStoryboard(
            name: "mainNav",
            bundle: Bundle.main
        )
        let controller = sMain
            .instantiateViewController(
                withIdentifier: "mainNav"
            ) as! MainContentViewController
        
        controller.view.alpha = 0
        push(
            controller,
            animDuration: 2.0
        ) {
            controller.view.alpha = 1.0
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
        appendController(c)
        
        UIView.animate(
            withDuration: animDuration,
            animations: animate
        )
    }
    
    public func pop(
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
