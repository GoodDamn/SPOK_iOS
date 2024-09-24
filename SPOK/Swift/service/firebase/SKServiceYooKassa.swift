//
//  SKServiceYooKassa.swift
//  SPOK
//
//  Created by GoodDamn on 20/09/2024.
//

import Foundation
import FirebaseDatabase

final class SKServiceYooKassa {
    
    weak var onGetApiKey: SKListenerOnGetYooKassaApiKey? = nil
    weak var onGetPaymentInfo: SKListenerOnGetPaymentInfo? = nil
    
    private let mReference = Database
        .database()
        .reference(
            withPath: "API_KEYS/" + .keyApiYoo()
        )
    
    final func getPaymentInfoAsync(
        payId: String
    ) {
        var req = URLRequest(
            url: Keys.URL_PAYMENTS.append(
                payId
            )
        )
        
        req.setValue(
            "Basic \(Keys.AUTH)",
            forHTTPHeaderField: "Authorization"
        )
        req.httpBody = nil
        
        req.downloadData { [weak self] data in
            
            guard let jsonRaw = data.json() else {
                Log.d(
                    SKServiceYooKassa.self,
                    "error:"
                )
                return
            }
            
            Log.d(
                SKServiceYooKassa.self,
                "paymenInfo:",
                jsonRaw
            )
            
            self?.onGetPaymentInfo?.onGetPaymentInfo(
                info: .json(
                    raw: jsonRaw
                )
            )
        }
    }
    
    final func getApiKeyAsync() {
        mReference.observeSingleEvent(
            of: .value
        ) { [weak self] snap in
            
            guard let apikey = snap.value as? String else {
                Log.d(
                    SKServiceYooKassa.self,
                    "apiKey: INVALID"
                )
                return
            }
            
            self?.onGetApiKey?.onGetYooKassaApiKey(
                key: apikey
            )
        }
    }
    
}
