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
    
}
