//
//  ViewUtils.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

public class ViewUtils {
    
    public static func button(
        text: String,
         y: CGFloat,
        _ view: UIView
    ) -> UIButton {
        
        let w = view.frame.width
        let h = view.frame.height
        
        let wbtn = w * 0.702
        
        let btnStart = UIButton(
            frame: CGRect(
                x: (w - wbtn) * 0.5,
                y: h * y,
                width: wbtn,
                height: h * 0.05
            )
        )
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 0.26 * btnStart.frame.height
        )
        
        btnStart.backgroundColor = UIColor(
            named: "btnBack"
        )
        
        btnStart
            .layer
            .cornerRadius = 0.17 * btnStart.frame.height
        
        btnStart.titleLabel?.font = bold
        btnStart.setTitleColor(
            .white,
            for: .normal
        )
        
        btnStart.setTitle(
            text,
            for: .normal)
        
        
        return btnStart
    }
    
}
