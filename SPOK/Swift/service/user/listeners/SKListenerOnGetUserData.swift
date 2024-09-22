//
//  SKListenerOnGetUserData.swift
//  SPOK
//
//  Created by GoodDamn on 21/09/2024.
//

import Foundation

protocol SKListenerOnGetUserData
: AnyObject {
    
    func onGetUserData(
        key: String,
        data: Any?
    )
    
}
