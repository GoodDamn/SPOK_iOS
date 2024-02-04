//
//  PaymentInfo.swift
//  YooKassaTest
//
//  Created by GoodDamn on 01/02/2024.
//

import Foundation

struct PaymentInfo {
    let id: String
    let status: Status
    let paid: Bool
    let price: Float
    let currency: Currency
    let createdTime: Int
}
