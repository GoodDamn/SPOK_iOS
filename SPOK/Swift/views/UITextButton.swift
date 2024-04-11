//
//  UIButtonText.swift
//  SPOK
//
//  Created by GoodDamn on 10/04/2024.
//

import UIKit

final public class UITextButton
    : UIView {
    
    final var textColor: UIColor = .lightText
    final var text: String? = nil
    final var font: UIFont? = nil
    final var paddingV: CGFloat = 15
    final var paddingH: CGFloat = 15
    
    private final var mAttr: NSAttributedString? = nil
    
    override init(
        frame: CGRect
    ) {
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
        
        let res = CGRect(
            x: (rect.width - textBounds.width) * 0.5,
            y: (rect.height - textBounds.height) * 0.5,
            width: rect.width,
            height: rect.height
        )
        
        print(UITextButton.self, rect, res)
        
        mAttr!.draw(
            in: res
        )
    }
    
    public func layout() {
        guard let text = text else {
            return
        }
        
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
