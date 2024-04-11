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
        
        mAttr?.draw(
            in: rect
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
        
        frame.size.height = attr.size()
            .height
        
        setNeedsDisplay()
    }
    
}
