//
//  SKServiceYookassaPayment.swift
//  SPOK
//
//  Created by GoodDamn on 22/09/2024.
//

import Foundation

final class SKServiceYookassaPayment {
    
    weak var onCreatePayment: SKListenerOnCreatePayment? = nil
    
    deinit {
        Log.d(
            SKServiceYookassaPayment.self,
            "deinit()"
        )
    }
    
    final func paySubAsync(
        with payment: Payment,
        to email: String
    ) {
        let amountJson = [
            "value": payment.price,
            "currency": payment
                .currency
                .rawValue
        ] as [String: Any]
        
        let json = [
            "amount": amountJson,
            "capture": payment
                .withCapture,
            "confirmation": [
                "type": "redirect",
                "return_url": Keys.DEEP_LINK_SUB
            ],
            "receipt": [
                "customer": [
                    "email": email
                ],
                "items": [[
                    "description": payment
                        .description,
                    "quantity": 1,
                    "amount": amountJson,
                    "vat_code": 1,
                    "payment_mode": "full_payment",
                    "payment_subject": "commodity"
                ]]
            ]
        ] as [String: Any]
        
        HttpUtils.requestJson(
            to: Keys.URL_PAYMENTS,
            header: HttpUtils.header(),
            body: json,
            method: "POST"
        ) { [weak self] json in
            guard let s = self else {
                Log.d("PaymentProcess: requestJson: GC")
                return
            }
            
            let confirm = json[
                "confirmation"
            ] as? [String : String]
            
            let confirmUrl = confirm?[
                "confirmation_url"
            ] ?? "https://google.com"
            
            let paymentSnap = PaymentSnapshot(
                id: json["id"] as? String ?? "",
                confirmUrl: confirmUrl
            )
            
            Log.d(
                "Payment: Snapshot:",
                paymentSnap
            )
            
            Log.d(
                "Payment: start:",
                json
            )
            
            self?.onCreatePayment?.onCreatePayment(
                snapshot: paymentSnap
            )
        }
    }
    
}
