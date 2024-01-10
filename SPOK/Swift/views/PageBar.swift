//
//  PageBar.swift
//  SPOK
//
//  Created by GoodDamn on 10/01/2024.
//

import Foundation
import UIKit

class PageBar
    : UIView {
    
    private final let TAG = "PageBar:"
    
    private var mPages:[Line] = []
    
    public var mInterval: CGFloat = 0.05 {
        didSet {
            mInterval = mInterval * frame.width
            let m = maxPages
            maxPages = m
        }
    }
    
    public var mColorCurrent: UIColor = .blue {
        didSet {
            mLayerCurrent.strokeColor = mColorCurrent
                .cgColor
            setNeedsDisplay()
        }
    }
    
    public var mColorBack: UIColor = .gray {
        didSet {
            mLayerBack.strokeColor = mColorBack
                .cgColor
            setNeedsDisplay()
        }
    }
    
    public var maxPages: Int = 2 {
        didSet {
            mPages.removeAll()
            
            let wl = frame.height / 2
            
            let intervalPoints = CGFloat(maxPages - 1)
            
            let fillInter = mInterval * intervalPoints
            
            let w = frame.width - wl
            
            let fillPage = w - fillInter
            
            let wpage = fillPage / CGFloat(maxPages)
            
            var x:CGFloat = 0
            
            var prevPoint = CGPoint(
                x: x,
                y: wl
            )
            
            for _ in 0..<maxPages {
                
                let point = CGPoint(
                    x: x + wpage,
                    y: wl
                )
                
                mPages.append(Line(
                    from: prevPoint,
                    to: point)
                )
                
                print(TAG, "POINTS:", prevPoint, point)
                
                x += wpage + wl + mInterval
                
                prevPoint.x = x
                
            }
            
            setNeedsDisplay()
        }
    }
    
    public var mCurrentPage: Int = 0 {
        didSet {
            if maxPages < 1 {
                return
            }
            
            let p = mPages[mCurrentPage]
            
            mLayerCurrent.strokeStart = p.from.x / frame.width
            mLayerCurrent.strokeEnd = p.to.x / frame.width
            
            setNeedsDisplay()
        }
    }
    
    private let mLayerCurrent = CAShapeLayer()
    private let mLayerBack = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mLayerCurrent.strokeStart = 0.0
        
        layer.addSublayer(mLayerBack)
        layer.addSublayer(mLayerCurrent)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(
        _ rect: CGRect
    ) {
        
        if mPages.count < 1 {
            return
        }
        
        let wline = rect.height / 2
        let path = UIBezierPath()
        
        for l in mPages {
            path.move(to: l.from)
            path.addLine(to: l.to)
        }
        
        print(TAG, "PATH:",path.bounds)
        print(TAG, "VIEW:",bounds)
        print(TAG, "RECTL",rect)
        
        mLayerBack.fillColor = nil
        mLayerBack.lineWidth = wline
        mLayerBack.lineCap = .round
        mLayerBack.path = path.cgPath
        
        mLayerCurrent.fillColor = nil
        mLayerCurrent.lineWidth = wline
        mLayerCurrent.lineCap = .round
        mLayerCurrent.path = path.cgPath
        
        print(TAG, mLayerCurrent.strokeStart, mLayerCurrent.strokeEnd)
        
    }
    
    private struct Line {
        var from: CGPoint
        var to: CGPoint
    }
    
}
