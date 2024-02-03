//
//  SignedInAppleListener.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation

protocol SignInListener
    : AnyObject {
 
    func onSuccessSign(
        token: String,
        nonce: String,
        authCode: String
    )
    
    func onErrorSign(
        _ msg: String
    )
    
}
