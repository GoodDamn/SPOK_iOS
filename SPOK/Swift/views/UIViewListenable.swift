//
//  UIViewListenable.swift
//  SPOK
//
//  Created by GoodDamn on 13/04/2024.
//

import UIKit

public class UIViewListenable
    : UIView {
    
    final var onClick: ((UIView) -> Void)? = nil
    final var isAnimatedTouch = true
    
    public final override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let _ = touchLocation(
            touches
        ) else {
            return
        }
        
        onTouchBegin()
        
        if !isAnimatedTouch {
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
    
    public final override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        
    }
    
    public final override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        if !isAnimatedTouch {
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
    }
    
    public final override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let location = touchLocation(
            touches
        ) else {
            return
        }
        
        onTouchEnd()
        
        if isAnimatedTouch {
            animate(
                duration: 0.3
            ) { [weak self] in
                self?.scale(
                    x: 1.0,
                    y: 1.0
                )
            }
        }
        
        if notInsideBounds(location) {
            return
        }
        
        onClick?(
            self
        )
    }
    
    internal func onTouchBegin(){}
    internal func onTouchEnd(){}
    
    private final func touchLocation(
        _ touches: Set<UITouch>
    ) -> CGPoint? {
        touches.first?.location(
            in: self
        )
    }
    
    private final func insideBounds(
        _ point: CGPoint
    ) -> Bool {
        return !notInsideBounds(
            point
        )
    }
    
    private final func notInsideBounds(
        _ point: CGPoint
    ) -> Bool {
        point.x < 0 ||
        point.y < 0 ||
        point.x > bounds.width ||
        point.y > bounds.height
    }
}
