//
//  SignedInAppleListener.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import FirebaseAuth

protocol SignInListener
    : AnyObject {
 
    func onSuccessSign(
        credentials: AuthCredential
    )
    
    func onErrorSign(
        _ msg: String
    )
    
}
