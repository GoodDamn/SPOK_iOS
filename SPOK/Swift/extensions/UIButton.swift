//
//  UIButton.swift
//  SPOK
//
//  Created by GoodDamn on 03/02/2024.
//

import Foundation
import UIKit.UIButton

extension UIButton {
    
    func click(
        for target: Any?,
        action: Selector
    ) {
        
        addTarget(
            target,
            action: action,
            for: .touchUpInside
        )
        
    }
    
}
