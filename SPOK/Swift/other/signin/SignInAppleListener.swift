//
//  SignInAppleListener.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import FirebaseAuth
import UIKit.UIView

protocol SignInAppleListener
    : AnyObject {
    
    func onAnchor(
    ) -> UIView
    
    func onSuccess(
        credentials: AuthCredential,
        def: UserDefaults
    )
    
    func onError(
        _ msg: String
    )
}
