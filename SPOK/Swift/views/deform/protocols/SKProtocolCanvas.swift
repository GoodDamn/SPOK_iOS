//
//  SKProtocolCanvas.swift
//  SPOK
//
//  Created by GoodDamn on 07/10/2024.
//

import Foundation
import CoreGraphics

protocol SKProtocolCanvas {
    
    var points: [CGPoint] { get set }
    
    var move: CGPoint { get set }
    
    func draw(
        canvas: inout CGContext
    )
}
