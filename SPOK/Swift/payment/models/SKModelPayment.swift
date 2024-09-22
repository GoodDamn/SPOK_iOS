//
//  SKModelPayment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

struct SKModelPayment {
    let price: Float
    let currency: Currency
    let description: String
    let withCapture: Bool = true
    
    
    static func subscription() -> SKModelPayment {
        SKModelPayment(
            price: 169.00,
            currency: .rub,
            description: "Подписка SPOK на 1 месяц"
        )
    }
    
}
