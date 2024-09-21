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
    
    private let mReference = Database
        .database()
        .reference(
            withPath: "API_KEYS/\(Keys.API_YOO)"
        )
    
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
