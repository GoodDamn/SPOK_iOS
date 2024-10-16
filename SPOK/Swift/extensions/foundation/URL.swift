//
//  URL.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
extension URL {
    
    static func yookassaPayments() -> URL {
        URL(
            string: "https://api.yookassa.ru/v3/payments"
        )!
    }
    
    func request() -> URLRequest {
        URLRequest(
            url: self
        )
    }
    
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
