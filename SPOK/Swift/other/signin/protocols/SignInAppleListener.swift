//
//  SignInAppleListener.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation

protocol SignInAppleListener
    : AnyObject {
    
    func onSuccess(
        token: String,
        nonce: String,
        authCode: String
    )
    
    func onError(
        _ msg: String
    )
    
}
