//
//  SKListenerOnGetAppleProtect.swift
//  SPOK
//
//  Created by GoodDamn on 23/09/2024.
//

import Foundation

protocol SKListenerOnGetPiratedState
: AnyObject {
    
    func onGetPiratedState(
        isPirated: Bool
    )
}
