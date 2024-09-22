//
//  SKListenerOnGetPaymentInfo.swift
//  SPOK
//
//  Created by GoodDamn on 21/09/2024.
//

import Foundation

protocol SKListenerOnGetPaymentInfo
: AnyObject {
    
    func onGetPaymentInfo(
        info: SKModelPaymentInfo?
    )
    
}
