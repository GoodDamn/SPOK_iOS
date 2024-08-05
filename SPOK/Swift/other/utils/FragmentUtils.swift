//
//  FragmentUtils.swift
//  SPOK
//
//  Created by GoodDamn on 18/06/2024.
//

import Foundation
import UIKit.UIApplication
import StoreKit.SKStoreProductViewController

final class FragmentUtils {
    
    static func openAppStorePage() {
        let store = SKStoreProductViewController()
        
        store.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: NSNumber(
                    value: 6443976042
                )
            ]
        )
        
        Utils.main()
            .present(
                store,
                animated: true
            )
    }
    
    static func openUrl(
        urls: String
    ) {
        let app = UIApplication.shared
        
        guard let url = URL(
            string: urls
        ) else {
            Log.d(
                "ProfileNewViewController",
                "URL_ERROR:"
            )
            return
        }
                
        app.open(url) { success in
            if success {
                Log.d("SUCCESS")
            }
        }
    }
}
