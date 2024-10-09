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
    
    var radius: CGFloat = 5 {
        didSet {
            maxProgressX = frame.width - radius
            mDtProgress = maxProgressX - radius
        }
    }
    var progress: CGFloat = 0.5
    
    final weak var onChangeProgress: SKIListenerOnChangeProgress? = nil
    
    private var maxProgressX: CGFloat = 0
    private var mDtProgress: CGFloat = 0
    
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
        
        let pp = CGPoint(
            x: x + mDtProgress * progress,
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
                x: maxProgressX,
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
        
        let x = touch.location(
            in: self
        ).x
        
        if x < radius {
            progress = 0
        } else if x > maxProgressX {
            progress = 1.0
        } else {
            progress = (x-radius) / mDtProgress
        }
        
        onChangeProgress?.onChangeProgress(
            progress: progress
        )
        
        setNeedsDisplay()
    }
    
}
