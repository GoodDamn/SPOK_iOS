//
//  SKListenerOnGetPremiumStatus.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation

protocol SKListenerOnGetPremiumStatus
: AnyObject {
    
    func onGetPremiumStatus(
        hasPremium: Bool
    )
    
}
