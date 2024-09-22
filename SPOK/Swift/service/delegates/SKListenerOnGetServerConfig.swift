//
//  SKListenerOnGetServerConfig.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation

protocol SKListenerOnGetServerConfig
: AnyObject {
    
    func onGetServerConfig(
        model: SKModelServerConfig
    )
    
}
