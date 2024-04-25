//
//  UIShitTextView.swift
//  SPOK
//
//  Created by GoodDamn on 24/04/2024.
//

import UIKit

final class UIShitTextView
    : UITextView {
    
    final var isUnderlinedText = false
    final var textImage: UIImage? {
        didSet {
            mAttachment.image = textImage
        }
    }
    
    final var paddingV: CGFloat = 15
    final var paddingH: CGFloat = 15
    
    final var urls: [String: URLAction]? = nil

    private final var mAttachment = NSTextAttachment()
    
    private final var mParagraph =
        NSMutableParagraphStyle()
    
    override var font: UIFont? {
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
    
    
    override var textAlignment: NSTextAlignment {
        didSet {
            mParagraph.alignment = textAlignment
        }
    }
    
    public final func layout() {
        
        delegate = self
        
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
        
        if urls != nil {
            for u in urls! {
                let r = attr.mutableString
                    .range(
                        of: u.value.id
                    )
                
                attr.addAttribute(
                    .link,
                    value: URL(
                        fileURLWithPath: u.key
                    ),
                    range: r
                )
            }
            
        }
        
        let size = attr.size()
        
        frame = CGRect(
            x: frame.origin.x - paddingH,
            y: frame.origin.y - paddingV,
            width: size.width + paddingH,
            height: size.height + paddingV
        )
        
        attributedText = attr
    }
    
}

struct URLAction {
    let id: String
    let action: (UIView) -> Void
}

extension UIShitTextView
    : UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let a = urls?[URL.lastPathComponent]
        a?.action(self)
        return true
    }
    
}

extension UIShitTextView {
    
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
