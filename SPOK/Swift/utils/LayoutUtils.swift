//
//  LayoutUtils.swift
//  SPOK
//
//  Created by GoodDamn on 16/01/2024.
//

import Foundation
import UIKit

final class LayoutUtils {
   
    public static func shitTextView(
        for b: UIShitTextView,
        size view: CGSize,
        textSize: CGFloat = 0.03,
        paddingHorizontal: CGFloat,
        paddingVertical: CGFloat
    ) {
        
        b.paddingH = view.width * paddingHorizontal
        b.paddingV = view.height * paddingVertical
        b.font = b.font?.withSize(
            textSize * view.height
        )
        
        b.layout()
        
    }
    
    public static func textButton(
        for b: UITextButton,
        size view: CGSize,
        textSize: CGFloat = 0.03,
        paddingHorizontal: CGFloat,
        paddingVertical: CGFloat
    ) {
        
        b.paddingH = view.width * paddingHorizontal
        b.paddingV = view.height * paddingVertical
        b.font = b.font?.withSize(
            textSize * view.height
        )
        
        b.layout()
        
    }
    
    public static func button(
        for b: UIButton?,
        _ viewFrame: CGRect,
        y: CGFloat,
        width: CGFloat = 0.702,
        height: CGFloat = 0.051,
        cornerRadius: CGFloat = 0.2,
        textSize: CGFloat = 0.29
    ) {
        
        guard let b = b else {
            return
        }
        
        let w = viewFrame.width
        let h = viewFrame.height
        
        let wbtn = w * width
        
        let c = CGRect(
            x: (w - wbtn) * 0.5,
            y: h * y,
            width: wbtn,
            height: h * height
        )
        
        b.frame = c
        
        let t = b.titleLabel
        t?.font = t?.font
            .withSize(textSize *
                b.frame.height
            )
        
        b.layer.cornerRadius = cornerRadius *
            b.frame.height
        
    }
    
}
