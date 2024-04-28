//
//  DispatchQueue.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation

extension DispatchQueue {
    
    static func ui(
        _ c: @escaping () -> Void
    ) {
        
        DispatchQueue
            .main
            .async(
                execute: c
            )
        
    }
    
    static func ui(
        wait: TimeInterval,
        _ c: @escaping () -> Void
    ) {
        
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + wait,
                execute: c
            )
        
    }
    
    static func back(
        _ c: @escaping () -> Void
    ) {
        DispatchQueue.global(
            qos: .userInitiated
        ).async(
            execute: c
        )
    }
    
}
