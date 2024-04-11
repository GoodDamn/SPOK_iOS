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
    
    func animate(
        duration: TimeInterval = 0.5,
        animations: @escaping () -> Void,
        completion: ((Bool)->Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            animations: animations,
            completion: completion
        )
    }
    
    func bottomy() -> CGFloat {
        frame.origin.y + frame.height
    }
    
    func width() -> CGFloat {
        frame.width
    }
    
    func height() -> CGFloat {
        frame.height
    }
    
    func corner(
        normHeight: CGFloat
    ) {
        layer.cornerRadius = frame.height * normHeight
        layer.masksToBounds = true
    }
    
    func centerH(
        in view: UIView
    ) {
        frame.origin.x = (view.frame.width -
            frame.width) * 0.5
    }
    
}
