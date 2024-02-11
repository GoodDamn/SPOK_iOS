//
//  Sheep.swift
//  SPOK
//
//  Created by GoodDamn on 10/02/2024.
//

import Foundation
import UIKit

final class Sheep
    : UIImageView {
    
    private var mAmpJump: CGFloat = 0
    private var mAngle: CGFloat = 0
    private var mOrigin: CGPoint = .zero
    
    deinit {
        Log.d("Sheep: deinit()")
    }
    
    override init(
        frame: CGRect
    ) {
        mAmpJump = frame.height * -0.8
        mAngle = -25/180 * .pi
        super.init(frame: frame)
        image = UIImage(
            named: "sheep"
        )
        mOrigin = center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    final func jump(
        onX: CGFloat
    ) {
        
        center.x += onX + frame.width
        center.y += mAmpJump
                
        transform = CGAffineTransform(
            rotationAngle: mAngle
        )
        
    }
    
    final func land() {
        
        center = mOrigin
        
        transform = CGAffineTransform(
            rotationAngle: 0
        )
    }
    
    final func jumpAnim(
        onX: CGFloat
    ) {
        UIView.animate(
            withDuration: 0.8,
            animations: {
                self.jump(
                    onX: onX
                )
            }
        ) { b in
            self.removeFromSuperview()
        }
    }
    
    final func landAnim() {
        UIView.animate(
            withDuration: 0.8
        ) {
            self.land()
        }
    }
    
}
