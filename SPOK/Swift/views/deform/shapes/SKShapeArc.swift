//
//  SKShapeArc.swift
//  SPOK
//
//  Created by GoodDamn on 07/10/2024.
//

import Foundation
import UIKit

struct SKShapeArc
: SKProtocolCanvas {
    
    var points: [CGPoint] = [
        .zero
    ]
    
    var move: CGPoint = .zero
    
    var strokeColor = UIColor.black.cgColor
    var strokeWidth: CGFloat = 5
    var radius: CGFloat = 4
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = .pi
    
    func draw(
        canvas: inout CGContext
    ) {
        if move != .zero {
            canvas.move(
                to: move
            )
        }
        
        canvas.setLineWidth(
            strokeWidth
        )
        
        canvas.setLineCap(
            .round
        )
        
        canvas.setStrokeColor(
            strokeColor
        )
        
        canvas.addArc(
            center: points[0],
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        canvas.strokePath()
    }
    
}
