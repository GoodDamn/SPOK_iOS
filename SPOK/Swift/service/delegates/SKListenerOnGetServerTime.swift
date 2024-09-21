//
//  SKListenerOnGetServerTime.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation

protocol SKListenerOnGetServerTime
: AnyObject {
    
    func onGetServerTime(
        timeSec: Int
    )
    
}
