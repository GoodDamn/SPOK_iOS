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
