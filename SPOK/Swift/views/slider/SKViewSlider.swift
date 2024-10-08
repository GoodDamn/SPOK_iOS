//
//  SKViewSlider.swift
//  SPOK
//
//  Created by GoodDamn on 07/10/2024.
//

import Foundation
import UIKit.UIView

final class SKViewSlider
: UIView {
    
    var trackColor: CGColor = UIColor
        .black
        .cgColor
    
    var progressColor: CGColor = UIColor
        .darkGray
        .cgColor
    
    var backgroundProgressColor: CGColor = UIColor
        .white
        .cgColor
    
    var strokeWidth: CGFloat = 3
    
    var radius: CGFloat = 5
    var progress: CGFloat = 0.5
    
    override func draw(
        _ rect: CGRect
    ) {
        guard let canvas = UIGraphicsGetCurrentContext() else {
            return
        }
        
        canvas.setFillColor(
            trackColor
        )
        
        let x = radius
        let y = frame.height * 0.5
        let maxProgress = frame.width - radius
        
        let pp = CGPoint(
            x: x + maxProgress * progress,
            y: y
        )
        
        canvas.move(
            to: CGPoint(
                x: x,
                y: y
            )
        )
        
        canvas.addLine(
            to: CGPoint(
                x: frame.width - radius,
                y: y
            )
        )
        canvas.setLineCap(
            .round
        )
        canvas.setLineWidth(
            strokeWidth
        )
        canvas.setStrokeColor(
            backgroundProgressColor
        )
        canvas.strokePath()
        
        
        
        
        canvas.move(
            to: CGPoint(
                x: x,
                y: y
            )
        )
        canvas.addLine(
            to: pp
        )
        canvas.setStrokeColor(
            progressColor
        )
        canvas.strokePath()
        
        
        
        
        
        canvas.addArc(
            center: pp,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: false
        )
        
        canvas.fillPath()
    }
        
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first else {
            return
        }
        
        progress = touch.location(
            in: self
        ).x / frame.width
        
        setNeedsDisplay()
    }
    
}
