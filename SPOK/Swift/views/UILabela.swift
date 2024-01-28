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
    
    public var lineHeight: CGFloat = 1.0 {
        didSet {
            mParagraph.lineHeightMultiple = lineHeight
        }
    }
    
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
    
    public func attribute() {
        
        guard let text = text else {
            return
        }
        
        let a = NSMutableAttributedString(
            string: text
        )
        
        let range = NSRange(
            location: 0,
            length: text.count
        )
        
        print("UILabela: pointSize", font.pointSize)
        
        a.addAttribute(
            .font,
            value: font,
            range: range
        )
        
        a.addAttribute(
            .foregroundColor,
            value: textColor,
            range: range
        )
        
        mParagraph.alignment = textAlignment
        
        a.addAttribute(
            .paragraphStyle,
            value: mParagraph,
            range: range
        )
        
        attributedText = a
    }
    
}

