//
//  UIView.swift
//  SPOK
//
//  Created by GoodDamn on 13/02/2024.
//

import Foundation
import UIKit.UIView

extension UIView {
    
    func alpha(
        duration: TimeInterval = 0.5,
        _ a: CGFloat,
        completion: ((Bool) -> Void)? = nil
    ) {
        
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.alpha = a
            },
            completion: completion
        )
        
    }
    
    func width() -> CGFloat {
        frame.width
    }
    
    func height() -> CGFloat {
        frame.height
    }
    
}
