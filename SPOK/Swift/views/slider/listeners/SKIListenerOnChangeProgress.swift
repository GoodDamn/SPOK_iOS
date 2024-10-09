//
//  SKIListenerOnChangeProgress.swift
//  SPOK
//
//  Created by GoodDamn on 08/10/2024.
//

import Foundation

protocol SKIListenerOnChangeProgress
: AnyObject {
    
    func onChangeProgress(
        progress: CGFloat
    )
    
}
