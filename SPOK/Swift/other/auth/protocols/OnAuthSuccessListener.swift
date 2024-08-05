//
//  OnAuthSuccessListener.swift
//  SPOK
//
//  Created by GoodDamn on 04/08/2024.
//

import Foundation
import FirebaseAuth

protocol OnAuthSuccessListener
    : AnyObject {
    
    func onAuthSuccess(
        _ auth: AuthDataResult,
        authCode: String
    )
    
}
