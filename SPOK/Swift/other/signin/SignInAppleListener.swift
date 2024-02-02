//
//  SignInAppleListener.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import UIKit.UIView

protocol SignInAppleListener
    : AnyObject {
    
    func onAnchor(
    ) -> UIView
    
    func onSuccess(
        token: String,
        nonce: String,
        def: UserDefaults
    )
    
    func onError(
        _ msg: String
    )
}
