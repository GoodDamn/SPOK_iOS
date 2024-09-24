//
//  SKViewControllerNavigation.swift
//  SPOK
//
//  Created by GoodDamn on 23/09/2024.
//

import Foundation
import UIKit.UIViewController

class SKViewControllerNavigation
: UIViewController {
    
    private var mCurrentIndex = 0
    
    final func pusht(
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
    
    final func push(
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
    
    final func pop(
        duration: TimeInterval? = nil,
        animate: (()->Void)? = nil
    ) {
        pop(
            at: mCurrentIndex - 1,
            duration: duration,
            animate: animate
        )
    }
    
    final func pop(
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
