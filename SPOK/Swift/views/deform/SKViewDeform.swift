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

    var quads: [SKProtocolCanvas]? = nil {
        didSet {
            
            if quads == nil {
                return
            }
            
            for i in quads!.indices {
                for j in quads![i].points.indices {
                    quads![i].points[j].x *= frame.width
                    quads![i].points[j].y *= frame.height
                }
            }
        }
    }
    
    var isFillPath = false
    
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
        guard var canvas = UIGraphicsGetCurrentContext() else {
            return
        }
        
        quads?.forEach { it in
            it.draw(
                canvas: &canvas
            )
        }
        
        if isFillPath {
            canvas.fillPath()
        } else {
            canvas.strokePath()
        }
        
    }
    
}
