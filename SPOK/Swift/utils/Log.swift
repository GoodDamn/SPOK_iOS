//
//  Log.swift
//  SPOK
//
//  Created by GoodDamn on 04/02/2024.
//

import Foundation

class Log {
        
    public static func d(
        _ items: Any...
    ) {
        #if DEBUG
            print(
                items
            )
        #endif
    }
    
}
