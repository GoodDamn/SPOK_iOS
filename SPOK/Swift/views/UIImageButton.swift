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
    
    
    override public func draw(
        _ rect: CGRect
    ) {
        super.draw(
            rect
        )
        
        image?.draw(
            in: rect
        )
    }
    
}
