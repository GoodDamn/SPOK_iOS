//
//  SKShapeBezierQ.swift
//  SPOK
//
//  Created by GoodDamn on 07/10/2024.
//

import Foundation
import UIKit

struct SKShapeBezierQ
: SKProtocolCanvas {
    
    var points: [CGPoint] = [
        .zero,
        .zero
    ]
    
    var move: CGPoint = .zero
    
    var fillColor: CGColor = UIColor
        .black
        .cgColor
    
    
    func draw(
        canvas: inout CGContext
    ) {
        if move != .zero {
            canvas.move(
                to: move
            )
        }
        
        canvas.addQuadCurve(
            to: points[1],
            control: points[0]
        )
        
        canvas.setFillColor(
            fillColor
        )
        
        canvas.fillPath()
    }
    
    
}
