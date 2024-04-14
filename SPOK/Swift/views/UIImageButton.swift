//
//  UIImageButton.swift
//  SPOK
//
//  Created by GoodDamn on 13/04/2024.
//

import UIKit

final public class UIImageButton
    : UIViewListenable {
    
    final var image: UIImage? = nil
    
    final var scale = CGPoint(
        x: 1.0,
        y: 1.0
    ) {
        didSet {
            
            let w = frame.width
            let h = frame.height
            
            let ow = scale.x * w * 0.5
            let oh = scale.y * h * 0.5
            
            imageRect = CGRect(
                x: ow,
                y: oh,
                width: w - ow - ow,
                height: h - oh - oh
            )
            
        }
    }
    
    private final var imageRect: CGRect = .zero
    
    public override init(
        frame: CGRect
    ) {
        imageRect = frame
        super.init(
            frame: frame
        )
    }
    
    public required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
        imageRect = frame
    }
    
    override public func draw(
        _ rect: CGRect
    ) {
        super.draw(
            rect
        )
        
        image?.draw(
            in: imageRect
        )
    }
}
