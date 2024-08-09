//
//  UILinearLayout.swift
//  SPOK
//
//  Created by GoodDamn on 28/07/2024.
//

import UIKit

final class UILinearLayout
    : UIView {
    
    var paddingTop: CGFloat = 0
    
    override func addSubview(
        _ view: UIView
    ) {
        addSubview(
            view,
            centerHorizontally: true
        )
    }
    
    func addSubview(
        _ view: UIView,
        centerHorizontally: Bool = true
    ) {
        let last = subviews
            .last?
            .frame
        
        let lastY = (last?
            .origin
            .y ?? paddingTop) + (last?.height ?? 0)
        
        if view.height() == 0 {
            view.sizeToFit()
        }
        view.frame.origin.y += lastY
        
        if centerHorizontally {
            view.centerH(
                in: self
            )
        }
        
        frame.size.height = view.frame.origin.y +
            view.frame.size.height
        
        super.addSubview(
            view
        )
    }
    
}
