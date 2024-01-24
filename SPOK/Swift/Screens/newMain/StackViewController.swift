//
//  StackViewController.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

class StackViewController
    : UIViewController {
    
    private final let TAG = "StackViewController"
    
    public final let mInsets = {
        let w = UIApplication
            .shared
            .windows
            .first
        
        return w?.safeAreaInsets ?? UIEdgeInsets.zero
    }()
    
    private var main: MainViewController!
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(animated)
        
        main = Utils.main()
    }
    
    public func framee(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> CGRect {
        return CGRect(
            x: x,
            y: y+mInsets.top,
            width: width,
            height: height
        )
    }
    
    open func push(
        _ c: StackViewController,
        animDuration: TimeInterval,
        animate: @escaping () -> Void
    ) {
        main.push(
            c,
            animDuration: animDuration,
            animate: animate
        )
        
    }
    
    open func pusht(
        _ c: StackViewController,
        animDuration: TimeInterval,
        options: UIView.AnimationOptions,
        completion: ((Bool)-> Void)?
    ) {
        
        main.pusht(
            c,
            animDuration: animDuration,
            options: options,
            completion: completion
        )
        
    }
    
    open func pop(
        duration: TimeInterval? = nil,
        animate: (() -> Void)? = nil
    ) {
        main.pop(
            duration: duration,
            animate: animate
        )
    }
    
    open func pop(
        at: Int,
        duration: TimeInterval? = nil,
        animate: (() -> Void)? = nil
    ) {
        main.pop(
            at: at,
            duration: duration,
            animate: animate
        )
    }
    
}
