//
//  KeyboardViewController.swift
//  SPOK
//
//  Created by GoodDamn on 08/08/2024.
//

import Foundation
import UIKit

class KeyboardViewController
    : StackViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NotificationCenter.default
        
        center.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notify in
                self?.onKeyboardWillShow(
                    notify
                )
            }
        )
        
        center.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notify in
                self?.onKeyboardWillHide()
            }
        )
        
    }
    
    
    internal func onKeyboardWillShow(
        _ n: Notification
    ) {
        view.frame.origin.y = -n.keyboardFrame().height
    }
    
    internal func onKeyboardWillHide() {
        view.frame.origin.y = 0
    }
    
}
