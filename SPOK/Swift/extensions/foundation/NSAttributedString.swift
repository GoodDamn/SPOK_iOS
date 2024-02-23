//
//  NSMutableAttributedString.swift
//  SPOK
//
//  Created by GoodDamn on 22/02/2024.
//

import Foundation
import UIKit.UIImage

extension NSAttributedString {
    
    static func withImage(
        text: NSAttributedString,
        pointSize: CGFloat,
        image: UIImage?,
        isRight: Bool = true
    ) -> NSAttributedString {
        
        guard let img = image else {
            return text
        }
        
        let attach = NSTextAttachment(
            image: img
        )
        
        let g = pointSize * 1.3
        
        attach.bounds = CGRect(
            x: 0,
            y: pointSize * -0.25,
            width: pointSize,
            height: pointSize
        )
        
        let imgAttr = NSMutableAttributedString(
            attachment: attach
        )
        
        if isRight {
            let result = NSMutableAttributedString(
                attributedString: text
            )
            
            result.append(
                imgAttr
            )
            
            return result
        }
        
        imgAttr.append(
            text
        )
        
        return imgAttr
        
    }
    
}
