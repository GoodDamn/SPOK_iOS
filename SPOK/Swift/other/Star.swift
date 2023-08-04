//
//  Star.swift
//  SPOK
//
//  Created by Cell on 31.12.2021.
//

import UIKit;

@IBDesignable
class Star:UIView{
    
    private let fillLayer:CAShapeLayer = CAShapeLayer();
    private var isFilled:Bool = false;
    
    @IBInspectable var maxProgress:Float=10.0;
    
    @IBInspectable var progress:Float=0.0{
        didSet{
            print("Star: progress trigger:", progress);
            
            if (progress > maxProgress && !isFilled)
            {
                fillLayer.strokeEnd = 1.0;
                isFilled = true;
                UIView.animate(withDuration: 0.5,   animations:{
                    self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.0);
                    }){ done in
                        if done{
                            UIView.animate(withDuration:    0.18, animations: {
                                self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0);
                                });
                        }
                    }
            } else if (progress < maxProgress){
                isFilled = false;
                fillLayer.strokeEnd = CGFloat(progress/maxProgress);
            }
        }
    }
    
    @IBInspectable var strokeWidth:CGFloat=3.8{
        didSet{
            setNeedsDisplay();
        }
    }
    
    private static func drawLine(from:CGPoint, to:CGPoint, path:UIBezierPath, onlyStroke:Bool){
        if (onlyStroke){
            path.move(to: from);
        }
        path.addLine(to: to);
    }
    
    static func createStarPath(onlyStroke:Bool, _ bounds:CGRect)->UIBezierPath{
        let starPath = UIBezierPath();
        let halfWidth = bounds.width/2;
        let halfHeight = bounds.height/2;
        
        let y = 0.36*(halfHeight+halfHeight);
        let x = 0.35*(halfWidth+halfWidth)+1.7;
        var p = CGPoint(x:x, y: y);
        
        if (!onlyStroke){
            starPath.move(to: CGPoint(x: halfWidth, y: 5));
        }
        
        drawLine(from: CGPoint(x: halfWidth, y: 5),
             to: p,
             path: starPath,
             onlyStroke: onlyStroke);
        
        var p1 = CGPoint(x: 5, y: y+3);
        drawLine(from: p,to: p1,
             path: starPath,
             onlyStroke: onlyStroke);
        
        p = CGPoint(x: x-6, y: halfHeight+y/3);
        drawLine(from: p1, to: p, path: starPath,
                 onlyStroke: onlyStroke);
        
        p1 = CGPoint(x:(p.x+2)*0.78, y: bounds.height-5);
        drawLine(from: p, to: p1, path: starPath,
                 onlyStroke: onlyStroke);
        
        p = CGPoint(x: halfWidth, y:bounds.height-10);
        drawLine(from: p1, to: p, path: starPath,
                 onlyStroke: onlyStroke);
        
        p1 = CGPoint(x: bounds.width-p1.x, y: p1.y);
        drawLine(from: p, to: p1, path: starPath,
                 onlyStroke: onlyStroke);
        
        p = CGPoint(x: bounds.width-x+6, y: halfHeight+y/3);
        drawLine(from: p1, to: p, path: starPath,
                 onlyStroke: onlyStroke);
        
        p1 = CGPoint(x: bounds.width-5, y: y+3);
        drawLine(from: p, to: p1, path: starPath,
                 onlyStroke: onlyStroke);
        
        p = CGPoint(x:bounds.width-x, y: y);
        drawLine(from: p1, to: p, path: starPath,
                 onlyStroke: onlyStroke);
        
        drawLine(from: p, to: CGPoint(x: halfWidth, y: 5), path: starPath, onlyStroke: onlyStroke);
        
        return starPath;
    }
    
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil;
        let maskLayer = CAShapeLayer();
        maskLayer.path = Star.createStarPath(onlyStroke: false, bounds).cgPath;
        
        maskLayer.lineWidth = strokeWidth;
        maskLayer.lineCap = .round;
        maskLayer.lineJoin = .round;
        
        let backgroundLayer = CAShapeLayer();
        backgroundLayer.path = Star.createStarPath(onlyStroke: true,bounds).cgPath;
        backgroundLayer.lineWidth = strokeWidth;
        backgroundLayer.lineCap = .round;
        backgroundLayer.lineJoin = .round;
        backgroundLayer.strokeColor = UIColor(named: "AccentColor")?.cgColor;
        
        let fillPath = UIBezierPath();
        fillPath.move(to: CGPoint(x: bounds.width/2, y: bounds.height));
        fillPath.addLine(to: CGPoint(x: bounds.width/2, y: 0));
        fillLayer.path = fillPath.cgPath;
        fillLayer.strokeColor = UIColor(named: "star_fill")?.cgColor;
        fillLayer.strokeStart = 0;
        fillLayer.strokeEnd = 0;
        fillLayer.lineWidth = bounds.width;
        fillLayer.lineCap = .butt;
        
        layer.addSublayer(backgroundLayer);
        layer.addSublayer(fillLayer);
        
        layer.mask = maskLayer;
    }
}
