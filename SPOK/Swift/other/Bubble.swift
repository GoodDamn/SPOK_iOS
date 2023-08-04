//
//  Bubble.swift
//  SPOK
//
//  Created by Cell on 12.03.2022.
//

import UIKit

@IBDesignable
class Bubble: UIView {
    override func draw(_ rect: CGRect) {
        let bubble = CAShapeLayer();
        bubble.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: bounds.height/2-8, startAngle: 0.0, endAngle: .pi * 2, clockwise: true).cgPath;
        bubble.strokeColor = UIColor(named: "AccentColor")?.cgColor;
        bubble.fillColor = UIColor(named: "background")?.cgColor;
        bubble.lineWidth = 4.0;
        
        layer.addSublayer(bubble);
    }
}
