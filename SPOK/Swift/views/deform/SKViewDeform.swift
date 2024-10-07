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

    var quads: [SKModelDeformQuad]? = nil
    
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
        print("draw::")
        guard let canvas = UIGraphicsGetCurrentContext() else {
            print("canvas = nil")
            return
        }
        
        print("draw::", quads?.count)
        
        quads?.forEach { it in
            canvas.move(
                to: it.from
            )
            
            canvas.addQuadCurve(
                to: it.to,
                control: it.control
            )
            
        }
        canvas.setFillColor(
            UIColor.systemBlue.cgColor
        )
        canvas.fillPath()
    }
    
}
