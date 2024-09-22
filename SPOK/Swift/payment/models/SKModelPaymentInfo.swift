//
//  SKModelPaymentInfo.swift
//  YooKassaTest
//
//  Created by GoodDamn on 01/02/2024.
//

import Foundation

struct SKModelPaymentInfo {
    let id: String
    let status: Status
    let paid: Bool
    let price: Float
    let currency: Currency
    let createdTime: Int
    
    
    static func json(
        raw json: [String : Any]
    ) -> SKModelPaymentInfo? {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        guard let status = Status(
            rawValue: json["status"] as? String ?? ""
        ) else {
            return nil
        }
        
        let paid = json["paid"] as! Bool
        
        let amount = json["amount"] as! [String : String]
        
        let price = Float(
            amount["value"]! as String
        )
        
        let currency = Currency(
            rawValue: amount[
                "currency"
            ]! as String
        )
        
        let createdTime = (json[
            "created_at"
        ] as? String)?.iso8601Epoch() ?? 0
        
        return SKModelPaymentInfo(
            id: id,
            status: status,
            paid: paid,
            price: price!,
            currency: currency!,
            createdTime: createdTime
        )
    }
    
}
