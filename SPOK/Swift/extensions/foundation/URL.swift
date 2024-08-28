//
//  URL.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
extension URL {
    func append(
        _ s: String
    ) -> URL {
            
        if #available(iOS 16.0, *) {
            return appending(
                path: s
            )
        }
            
        return appendingPathComponent(
            s
        )
    }
        
    func pathh() -> String {
        if #available(iOS 16.0, *) {
            return path()
        }
        
        return path
    }
}
