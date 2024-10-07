//
//  SKViewDeform.swift
//  SPOK
//
//  Created by GoodDamn on 07/10/2024.
//

import Foundation
import UIKit

final class SKViewDeform
: UIView {

    var quads: [SKModelDeformQuad]? = nil {
        didSet {
            
            if quads == nil {
                return
            }
            
            for i in 0..<quads!.count {
                var it = quads![i]
                
                it.control.x *= frame.width
                it.control.y *= frame.height
                
                it.to.x *= frame.width
                it.to.y *= frame.height
                
                quads![i] = it
            }
        }
    }
    
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
        guard let canvas = UIGraphicsGetCurrentContext() else {
            return
        }
        
        canvas.move(
            to: CGPoint(
                x: frame.width,
                y: 0
            )
        )
        
        quads?.forEach { it in
            
            canvas.addQuadCurve(
                to: it.to,
                control: it.control
            )
            
        }
        canvas.setFillColor(
            tintColor.cgColor
        )
        canvas.fillPath()
    }
    
}
