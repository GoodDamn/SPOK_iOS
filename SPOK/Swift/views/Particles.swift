//
//  Particles.swift
//  ParticlesFX
//
//  Created by GoodDamn on 18/01/2024.
//

import Foundation
import UIKit

class Particles
    : UIView {
    
    // This solution sucks (@Deprecated)
    // It needs to use the OpenGL (Metal idk)
    // with Perlin's noise
    // It's more efficient
    
    private let TAG = "Particles:"
    
    private let mLayers = 5
    private let mObjs = 20
    
    // 100 particles = 5 * 20
    
    private var mTimer: Timer? = nil
    
    private var mParticles: [Particle] = []
    
    private var mElapsedTime: Float = 0
    
    public var mRadius: CGFloat = 3 {
        didSet {
            mRadius = mRadius * frame.width
        }
    }
    
    private func ini() {
        
        for _ in 0..<mLayers {
            let a = CAShapeLayer()
            
            a.fillColor = UIColor
                .white
                .cgColor
            a.strokeColor = nil
            
            
            let p = generateParticle()
            a.path = p.path
                .cgPath
            
            mParticles.append(
                p
            )
            layer.addSublayer(a)
        }
    }
    
    init(
        frame: CGRect,
        radius: CGFloat
    ) {
        mRadius = radius
        super.init(frame: frame)
        ini()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ini()
    }

    public func stop() {
        mTimer?.invalidate()
        mTimer = nil
    }
    
    public func start() {
        var prevTime = Date()
            .timeIntervalSince1970
        
        mTimer = Timer.scheduledTimer(
            withTimeInterval: 0.25,
            repeats: true
        ) { _ in
            
            let m = self.mParticles
            
            for i in m.indices {
                self.dOpacity(
                    index: i
                )
            }
        }
        
    }
    
    private func dOpacity(
        index: Int
    ) {
        let par = mParticles[index]
        
        let l = layer
            .sublayers![index]
        as! CAShapeLayer
        
        l.opacity -= 0.25
        
        
        if l.opacity < 0.1 {
            mParticles[index] = generateParticle()
            l.opacity = Float.random(
                in: 0.5..<1.0
            )
        }
    }
    
    private func generateParticle() -> Particle {
        let b = UIBezierPath()
        
        for _ in 0..<mObjs {
            let p = ranp()
            b.move(
                to: p
            )
            b.addArc(
                withCenter: p,
                radius: 3.0,
                startAngle: 0,
                endAngle: 2 * .pi,
                clockwise: true
            )
        }
        
        return Particle(
            lifeTime: Int.random(
                in: 100...200
            ),
            path: b
        )
        
    }
    
    private func ranp() -> CGPoint {
        return CGPoint(
            x: CGFloat.random(
                in: mRadius
                ...
                (frame.width-mRadius)
            ),
            y: CGFloat.random(
                in: mRadius
                ...
                (frame.height-mRadius)
            )
        )
    }
    
}

struct Particle {
    var lifeTime: Int
    var path: UIBezierPath
}
