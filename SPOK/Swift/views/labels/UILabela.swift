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
    
    public final var lineHeight: CGFloat = 1.0 {
        didSet {
            mParagraph.lineHeightMultiple = lineHeight
        }
    }
    
    public final var leftImage: UIImage? = nil
    
    public final var leftImageColor: UIColor = .blue
    
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
    
    public final func attribute() {
        
        guard let text = text else {
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
            return
        }
              
        attributedText = NSAttributedString
            .withImage(
                text: attrText,
                pointSize: font.pointSize,
                image: leftImage?.withTintColor(
                    leftImageColor,
                    renderingMode: .alwaysTemplate
                ),
                isRight: false
            )
    }
    
}

