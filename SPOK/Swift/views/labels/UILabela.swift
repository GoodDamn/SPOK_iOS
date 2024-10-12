//
//  AttributedLabel.swift
//  SPOK
//
//  Created by GoodDamn on 28/01/2024.
//

import Foundation
import UIKit

class UILabela
: UILabel {
    
    private var mParagraph = NSMutableParagraphStyle()
    
    final var isStrikethroughed = false
    
    final var lineHeight: CGFloat = 1.0 {
        didSet {
            mParagraph.lineHeightMultiple = lineHeight
            
        }
    }
    
    final var leftImage: UIImage? = nil
    
    final var leftImageColor: UIColor = .blue
    
    override init(frame: CGRect) {
        super.init(
            frame: frame
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
    override func sizeToFit() {
        guard let text = text else {
            super.sizeToFit()
            return
        }
        
        let attrText = NSMutableAttributedString(
            string: text
        )
        
        let range = NSRange(
            location: 0,
            length: text.count
        )
        
        attrText.addAttribute(
            .font,
            value: font,
            range: range
        )
        
        if isStrikethroughed {
            attrText.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle
                    .single
                    .rawValue,
                range: range
            )
            attrText.addAttribute(
                .strikethroughColor,
                value: textColor,
                range: range
            )
        }
        
        attrText.addAttribute(
            .foregroundColor,
            value: textColor,
            range: range
        )
        
        mParagraph.alignment = textAlignment
        
        attrText.addAttribute(
            .paragraphStyle,
            value: mParagraph,
            range: range
        )
        
        // Image attachment
        
        if leftImage == nil {
            attributedText = attrText
            super.sizeToFit()
            return
        }
              
        attributedText = NSAttributedString.withImage(
            text: attrText,
            pointSize: font.pointSize,
            image: leftImage?.withTintColor(
                leftImageColor,
                renderingMode: .alwaysTemplate
            ),
            isRight: false
        )
        super.sizeToFit()
    }
}

