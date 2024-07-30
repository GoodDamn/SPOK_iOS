//
//  UILinearLayout.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit

final class UILinearLayout
    : UIView {
    
    override func addSubview(
        _ view: UIView
    ) {
        let last = subviews
            .last?
            .frame
        
        let lastY = (last?
            .origin
            .y ?? 0) + (last?.height ?? 0)
        
        if view.height() == 0 {
            view.sizeToFit()
        }
        view.frame.origin.y += lastY
        
        view.centerH(
            in: self
        )
        
        frame.size.height = view.frame.origin.y +
            view.frame.size.height
        
        super.addSubview(
            view
        )
    }
    
}
