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
    
    final var onClick: ((UIView) -> Void)? = nil
    
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
 
    
    public override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let location = touchLocation(
            touches
        ) else {
            return
        }
        
        animate(
            duration: 0.3
        ) { [weak self] in
            self?.scale(
                x: 0.85,
                y: 0.85
            )
        }
        
    }
    
    public override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let location = touchLocation(
            touches
        ) else {
            return
        }
        
        animate(
            duration: 0.3
        ) { [weak self] in
            self?.scale(
                x: 1.0,
                y: 1.0
            )
        }
        
        if notInsideBounds(location) {
            return
        }
        
        onClick?(self)
    }
    
}

extension UITextButton {
    
    private func touchLocation(
        _ touches: Set<UITouch>
    ) -> CGPoint? {
        touches.first?.location(
            in: self
        )
    }
    
    private func insideBounds(
        _ point: CGPoint
    ) -> Bool {
        return !notInsideBounds(
            point
        )
    }
    
    private func notInsideBounds(
        _ point: CGPoint
    ) -> Bool {
        point.x < 0 ||
        point.y < 0 ||
        point.x > bounds.width ||
        point.y > bounds.height
    }
    
}
