//
//  SKListenerOnCreatePayment.swift
//  SPOK
//
//  Created by GoodDamn on 22/09/2024.
//

import Foundation

protocol SKListenerOnCreatePayment
: AnyObject {
    
    func onCreatePayment(
        snapshot: SKModelPaymentSnapshot
    )
    
}
