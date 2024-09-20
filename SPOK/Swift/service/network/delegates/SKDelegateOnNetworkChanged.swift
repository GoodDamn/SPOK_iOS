//
//  SKDelegateOnNetworkChanged.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation

protocol SKDelegateOnNetworkChanged
: AnyObject {
    
    func onNetworkChanged(
        isConnected: Bool
    )
    
}
