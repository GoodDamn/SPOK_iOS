//
//  OnReauthSuccessListener.swift
//  SPOK
//
//  Created by GoodDamn on 04/08/2024.
//

import Foundation
import FirebaseAuth

protocol OnReauthSuccessListener
    : AnyObject {
    
    func onReauthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    )
    
}
