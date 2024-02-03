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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        main = Utils.main()
    }
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(animated)
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
    
    @objc func onClickBtnClose(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        popBaseAnim()
    }
    
}
