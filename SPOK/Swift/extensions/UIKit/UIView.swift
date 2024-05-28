//
//  UIView.swift
//  SPOK
//
//  Created by GoodDamn on 13/02/2024.
//

import Foundation
import UIKit.UIView

extension UIView {
    
    func shadow(
        radius: CGFloat
    ) {
        layer.shadowOffset = CGSize(
            width: 0.5,
            height: 0.5
        )
        layer.shadowRadius = radius
    }
    
    func shadow(
        alpha: Float
    ) {
        layer.shadowOpacity = alpha
    }
    
    func shadow(
        color: UIColor?
    ) {
        layer.shadowColor = color?.cgColor
    }
    
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
    
    func scale(
        x: CGFloat = 1.0,
        y: CGFloat = 1.0
    ) {
        transform = CGAffineTransform(
            scaleX: x,
            y: y
        )
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
    
    func y(
        _ norm: CGFloat,
        in view: UIView
    ) {
        frame.origin.y = view.frame.height * norm
    }
    
}
