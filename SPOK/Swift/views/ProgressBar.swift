//
//  ProgressBar.swift
//  SPOK
//
//  Created by GoodDamn on 10/01/2024.
//

import Foundation
import UIKit

class ProgressBar
    : UIView {
    
    private final let TAG = "ProgressBar:"
    
    public var mColorProgress: UIColor = .blue {
        didSet {
            mLayerProgress.strokeColor = mColorProgress
                .cgColor
        }
    }
    
    public var mColorBack: UIColor = .gray {
        didSet {
            mLayerBack.strokeColor = mColorBack
                .cgColor
        }
    }
    
    public var maxProgress: CGFloat = 1.0 {
        didSet {
            print(TAG, "MAX:",maxProgress)
            mLayerProgress.strokeEnd = mProgress / maxProgress
        }
    }
    
    public var mProgress: CGFloat = 0.0 {
        didSet {
            print(TAG, "Prog:", mProgress, maxProgress)
            mLayerProgress.strokeEnd = mProgress / maxProgress * 0.5
        }
    }
    
    private let mLayerProgress = CAShapeLayer()
    private let mLayerBack = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(mLayerBack)
        layer.addSublayer(mLayerProgress)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(
        _ rect: CGRect
    ) {
        super.draw(rect)
        print(TAG, "draw:",rect, mLayerProgress.strokeEnd)
        let wline = rect.height * 0.5
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: wline,
            y: wline)
        )
        path.addLine(to: CGPoint(
            x: rect.width - wline,
            y: wline)
        )
        path.close()
        
        mLayerBack.fillColor = nil
        mLayerBack.lineWidth = wline
        mLayerBack.lineJoin = .round
        mLayerBack.path = path.cgPath
        
        mLayerProgress.fillColor = nil
        mLayerProgress.lineWidth = wline
        mLayerProgress.lineCap = .round
        mLayerProgress.path = path.cgPath
        
    }
    
}
