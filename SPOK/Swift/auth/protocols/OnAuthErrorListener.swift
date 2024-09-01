//
//  OnAuthErrorListener.swift
//  SPOK
//
//  Created by GoodDamn on 04/08/2024.
//

import Foundation

protocol OnAuthErrorListener
    : AnyObject {
    
    func onAuthError(
        error: String
    )
    
}
