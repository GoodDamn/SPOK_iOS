//
//  Payment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

final class PaymentProcess {
    
    private let mJson: [String : Any]
    
    private var mPaymentSnap: PaymentSnapshot? = nil
    
    deinit {
        Log.d("PaymentProcess: deinit()")
    }
    
    init(
        payment: Payment,
        email: String
    ) {
        let amountJS = [
            "value": payment.price,
            "currency": payment
                .currency
                .rawValue
        ] as [String : Any]
        
        mJson = [
            "amount": amountJS,
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
                    "amount": amountJS,
                    "vat_code": 1,
                    "payment_mode": "full_payment",
                    "payment_subject": "commodity"
                ]]
            ]
        ] as [String : Any]
    }
    
    public func start(
        completion: @escaping (PaymentSnapshot) -> Void
    ) {
        
        HttpUtils.requestJson(
            to: Keys.URL_PAYMENTS,
            header: HttpUtils.header(),
            body: mJson,
            method: "POST"
        ) { [weak self] json in
            guard let s = self else {
                Log.d("PaymentProcess: requestJson: GC")
                return
            }
            
            let confirm = json["confirmation"] as? [String : String]
            
            let confirmUrl = confirm?["confirmation_url"] ?? "https://google.com"
            
            s.mPaymentSnap = PaymentSnapshot(
                id: json["id"] as? String ?? "",
                confirmUrl: confirmUrl
            )
            
            Log.d(
                "Payment: Snapshot:",
                s.mPaymentSnap
            )
            
            Log.d(
                "Payment: start:",
                json
            )
            
            completion(s.mPaymentSnap!)
        }
        
    }
    
    
    public static func getPaymentInfo(
        id: String,
        completion: @escaping (PaymentInfo?) -> Void
    ) {
        
        var req = URLRequest(
            url: Keys.URL_PAYMENTS
                .appendingPathComponent(
                    id
                )
        )
        
        req.setValue(
            "Basic \(Keys.AUTH)",
            forHTTPHeaderField: "Authorization"
        )
        req.httpBody = nil
        
        URLSession.shared.dataTask(
            with: req
        ) { data, resp, error in
    
            
            guard let data = data else {
                return
            }
            
            do {
                
                let json = try JSONSerialization
                    .jsonObject(
                        with: data
                    ) as! [String : Any]
                
                Log.d(
                    "PaymentProcess: paymentInfo: JSON",
                    json
                )
                
                
                completion(
                    PaymentProcess
                        .extractPaymentInfo(
                            json
                    )
                )
                
                
            } catch {
                Log.d(
                    "PaymentProcess: paymentINFO:JSON",
                    error
                )
            }
            
        }.resume()
        
        
    }
    
    private static func extractPaymentInfo(
        _ json: [String : Any]
    ) -> PaymentInfo? {
        
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
            rawValue: amount["currency"]!
                    as String
        )
        
        let createdTime = (json["created_at"] as? String)?.iso8601Epoch() ?? 0
        
        return PaymentInfo(
            id: id,
            status: status,
            paid: paid,
            price: price!,
            currency: currency!,
            createdTime: createdTime
        )
        
    }
    
}
