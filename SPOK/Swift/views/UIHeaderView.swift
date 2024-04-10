//
//  UIHeaderView.swift
//  SPOK
//
//  Created by GoodDamn on 09/04/2024.
//

import UIKit

final class UIHeaderView
    : UIView {
    
    final var title: String = ""
    final var subtitle: String = ""
    final var titleSize: CGFloat = 15
    final var subtitleSize: CGFloat = 8
    final var spacing: CGFloat = 5
    
    private final var mAttr: NSMutableAttributedString? = nil
    
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
    
    
    override func draw(
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
        
        let attr = NSMutableAttributedString(
            string: "\(title)\n\n\(subtitle)"
        )
        
        let rangeTitle = NSRange(
            location: 0,
            length: title.count
        )
        
        attr.addAttribute(
            .foregroundColor,
            value: UIColor.white,
            range: NSRange(
                location: 0,
                length: attr.length
            )
        )
        
        attr.addAttribute(
            .font,
            value: UIFont.extrabold(
                withSize: titleSize
            ),
            range: rangeTitle
        )
        
        attr.addAttribute(
            .font,
            value: UIFont.systemFont(
                ofSize: spacing
            ),
            range: NSRange(
                location: title.count,
                length: 2
            )
        )
        
        attr.addAttribute(
            .font,
            value: UIFont.semibold(
                withSize: subtitleSize
            ),
            range: NSRange(
                location: title.count + 2,
                length: subtitle.count
            )
        )
        
        let s = attr.size()
        
        print(UIHeaderView.self, title, subtitle)
        
        mAttr = attr
        
        frame.size = s.rnd()
        setNeedsDisplay()
    }
    
}
