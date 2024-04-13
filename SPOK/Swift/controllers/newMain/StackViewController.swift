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
    
    public final let mInsets = {
        let w = UIApplication
            .shared
            .windows
            .first
        
        return w?.safeAreaInsets ?? UIEdgeInsets.zero
    }()
    
    private var main: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main = Utils.main()
    }
    
    public final func framee(
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
    
    public final func updatePremium() {
        onUpdatePremium()
    }
    
    public final func updateState() {
        onUpdateState()
    }
    
    public final func transitionEnd() {
        onTransitionEnd()
    }
        
    public final func pushBaseAnim(
        _ c: StackViewController,
        animDuration: TimeInterval
    ) {
        c.view.alpha = 0
        push(
            c,
            animDuration: animDuration
        ) {
            c.view.alpha = 1.0
        }
    }
    
    public final func callUpdatePremium() {
        main.superUpdatePremium()
    }
    
    
    open func push(
        _ c: StackViewController,
        animDuration: TimeInterval,
        animate: @escaping () -> Void,
        completion: ((Bool)->Void)? = nil
    ) {
        main.push(
            c,
            animDuration: animDuration,
            animate: animate,
            completion: completion
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
    
    open func popBaseAnim() {
        pop(
            duration: 0.3
        ) { [weak self] in
            self?.view.alpha = 0
        }
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
    
    internal func onTransitionEnd() {}
    internal func onUpdatePremium() {}
    internal func onUpdateState() {}
}
