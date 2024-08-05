//
//  FragmentUtils.swift
//  SPOK
//
//  Created by GoodDamn on 18/06/2024.
//

import Foundation
import UIKit.UIApplication

final class FragmentUtils {
    
    static func openAppStorePage(
        _ root: UIViewController
    ) {
        let vc = SKStoreProductViewController()
        
        vc.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: NSNumber(
                    value: 6443976042
                )
            ],
            completionBlock: nil
        )
        
        root.present(
            vc,
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
