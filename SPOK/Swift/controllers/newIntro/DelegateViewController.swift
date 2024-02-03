//
//  DelegateViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class DelegateViewController
    : UIViewController {
    
    var onHide: (()->Void)? = nil
    var onWillHide: (()->Void)? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.alpha = 0
    }
    
    public func hide() {
        onWillHide?()
        UIView.animate(
            withDuration: 2.0,
            animations: {
                self.view.alpha = 0
            }
        ) { b in
            self.onHide?()
        }
    }
    
    public func show(
        _ completion: (()->Void)? = nil
    ) {
        UIView.animate(
            withDuration: 1.5,
            animations: {
            self.view.alpha = 1
        }) { b in
            completion?()
        }
    }
}
