//
//  Payment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

struct Payment {
    let price: Float
    let currency: Currency
    let description: String
    let withCapture: Bool = true
}
