//
//  AttributedLabel.swift
//  SPOK
//
//  Created by GoodDamn on 28/01/2024.
//

import Foundation
import UIKit

final class UILabela
    : UILabel {
    
    private var mParagraph = NSMutableParagraphStyle()
    
    private var mImageAttach = NSTextAttachment()
    
    public var lineHeight: CGFloat = 1.0 {
        didSet {
            mParagraph.lineHeightMultiple = lineHeight
        }
    }
    
    public var leftImage: UIImage? = nil {
        didSet {
            mImageAttach.image = leftImage
        }
    }
    
    public var leftImageColor: UIColor = .blue {
        
        didSet {
            
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
        
        // Image attachment
        
        if mImageAttach.image == nil {
            attributedText = a
            return
        }
        
        let fontSize = font.pointSize
        let dy = fontSize * 0.25
        let imgSize = fontSize * 1.5
        
        mImageAttach.bounds = CGRect(
            x: 0,
            y: -dy,
            width: imgSize,
            height: imgSize
        )
        
        let tempImage = mImageAttach
            .image?
            .withTintColor(
                leftImageColor,
                renderingMode:
                    .alwaysTemplate
            )
        
        mImageAttach.image = tempImage
        
        let attachStr = NSMutableAttributedString(
            attachment: mImageAttach
        )
        
        attachStr.addAttribute(
            .foregroundColor,
            value: leftImageColor,
            range: NSRange(
                location: 0,
                length: 1
            )
        )
        
        attachStr.append(
            NSAttributedString(
                string: " "
            )
        )
        
        attachStr.append(
            a
        )
        
                
        attributedText = attachStr
    }
    
}

