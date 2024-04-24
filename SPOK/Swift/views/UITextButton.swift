//
//  UIButtonText.swift
//  SPOK
//
//  Created by GoodDamn on 10/04/2024.
//

import UIKit

final public class UITextButton
    : UIViewListenable {
    
    final var text: String? = nil
    final var textColor: UIColor = .lightText
    
    final var textImage: UIImage? = nil {
        didSet {
            mAttachment.image = textImage
        }
    }
    
    final var textAlignment: NSTextAlignment = .left {
        didSet {
            mParagraph.alignment = textAlignment
        }
    }
    
    final var font: UIFont? = nil {
        didSet {
            guard let size = font?.pointSize else {
                return
            }
            
            mAttachment.bounds = CGRect(
                x: 0,
                y: size * -0.25,
                width: size,
                height: size
            )
        }
    }
    
    final var isUnderlinedText = false
    
    final var paddingV: CGFloat = 15
    final var paddingH: CGFloat = 15
    
    private final var mAttr:
        NSAttributedString? = nil
    
    private final var mAttachment = NSTextAttachment()
    
    private final var mParagraph =
        NSMutableParagraphStyle()
    
    public override func draw(
        _ rect: CGRect
    ) {
        super.draw(
            rect
        )
        
        // Centered text in view
        guard let textBounds = mAttr?.size() else {
            return
        }
        
        let x = (rect.width - textBounds.width) * 0.5
        
        let y = (rect.height - textBounds.height) * 0.5
        
        let res = CGRect(
            x: x,
            y: y,
            width: rect.width - x - x + 1,
            height: rect.height - y - y + 1
        )
        
        mAttr!.draw(
            in: res
        )
    }
    
    public func layout() {
        guard let text = text else {
            return
        }
        
        let attr: NSMutableAttributedString =
        textImage == nil ? {
            let a = attributeWholeText(
                text
            )
            
            attributeParagraph(
                for: a
            )
            
            return a
        } () : {
            let attr = NSMutableAttributedString()
            attributeWithImage(
                to: attr,
                text: text
            )
            
            attributeParagraph(
                for: attr
            )
            return attr
        }()
        
        mAttr = attr
        
        let size = attr.size()
        
        frame = CGRect(
            x: frame.origin.x - paddingH,
            y: frame.origin.y - paddingV,
            width: size.width + paddingH,
            height: size.height + paddingV
        )
                
        setNeedsDisplay()
    }
    
}

extension UITextButton {
    
    private func attributeParagraph(
        for attr: NSMutableAttributedString
    ) {
        attr.addAttribute(
            .paragraphStyle,
            value: mParagraph,
            range: NSRange(
                location: 0,
                length: attr.length
            )
        )
    }
    
    private func attributeWithImage(
        to: NSMutableAttributedString,
        text: String
    ) {
        let arr = text.components(
            separatedBy: "$i"
        )
        
        var pos = 0
        for str in arr {
            
            if str.count == 0 {
                continue
            }
            
            pos += str.count
            
            let imageAtt = NSAttributedString(
                attachment: mAttachment
            )
            
            to.append(
                attributeWholeText(
                    str
                )
            )
            
            to.append(
                imageAtt
            )
            
        }
    }
    
    private func attributeWholeText(
        _ text: String
    ) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(
            string: text
        )
        
        let range = NSRange(
            location: 0,
            length: text.count
        )
        
        attr.addAttribute(
            .font,
            value: font,
            range: range
        )
        
        attr.addAttribute(
            .foregroundColor,
            value: textColor,
            range: range
        )
        
        if isUnderlinedText {
            attr.addAttribute(
                .underlineStyle,
                value: NSUnderlineStyle
                    .single
                    .rawValue,
                range: range
            )
        }
        
        return attr
    }
    
}
