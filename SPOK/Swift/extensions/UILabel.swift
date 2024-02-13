//
//  UILabel.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import UIKit.UILabel

extension UILabel {
    
    func setParagraph(
        string: String,
        style: NSMutableParagraphStyle
    ) {
        let a = NSMutableAttributedString(
            string: string
        )
        
        a.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(
                location: 0,
                length: string.count
            )
        )
        text = ""
        attributedText = a
    }
    
    func textHeight() -> CGFloat {
        return textHeight(
            width: frame.width
        )
    }
    
    func textHeight(
        width: CGFloat
    ) -> CGFloat {
        return systemLayoutSizeFitting(
            CGSize(
                width: frame.width,
                height: UIView
                    .layoutFittingCompressedSize
                    .height
            ),
            withHorizontalFittingPriority:
                    .required,
            verticalFittingPriority:
                    .fittingSizeLevel
        ).height
    }
    
}
