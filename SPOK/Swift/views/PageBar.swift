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
    
    private var mPages:[CGPoint] = []
    
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
            let interval = 0.05 * frame.width
            
            let fillInter = interval * intervalPoints
            
            let fillPage = frame.width - fillInter
            
            let wpage = fillPage / CGFloat(maxPages)
            
            var x = wl
            for i in 0..<maxPages {
                print(TAG, "CALC:", x, wl, wpage,interval, fillPage, fillInter)
                mPages.append(CGPoint(
                    x: x,
                    y: wl)
                )
                
                x += wpage
                
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
            var limit = frame.width
            
            let interval = 0.09 * frame.width
            
            if mCurrentPage+1 < maxPages {
                limit = mPages[mCurrentPage+1].x + interval
            }
            
            mLayerCurrent.strokeStart = (p.x+interval) / frame.width / 2
            mLayerCurrent.strokeEnd = limit / frame.width / 2
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
        
        var prevPoint = mPages[0]
        
        let interval = 0.09 * frame.width
        
        for i in 1..<mPages.count {
            var point = mPages[i]
            print(TAG,
                  "DRAW_POINT:",
                  prevPoint,
                  point)
            
            path.move(to: prevPoint)
            path.addLine(to: point)
            
            point.x += interval
            prevPoint = point
        }
        
        let lastp = CGPoint(
            x: rect.width,
            y: prevPoint.y
        )
        
        path.move(to: prevPoint)
        path.addLine(to: lastp)
        
        print(TAG,
              "DRAW_POINT:",
              prevPoint,
              lastp)
        
        path.close()
        
        mLayerBack.fillColor = nil
        mLayerBack.lineWidth = wline
        mLayerBack.lineCap = .round
        mLayerBack.path = path.cgPath
        
        mLayerCurrent.fillColor = nil
        mLayerCurrent.lineWidth = wline
        mLayerCurrent.lineCap = .round
        mLayerCurrent.path = path.cgPath
    }
    
}
