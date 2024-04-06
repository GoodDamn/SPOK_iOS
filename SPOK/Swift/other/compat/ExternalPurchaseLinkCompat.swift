//
//  ExternalPurchaseLinkCompat.swift
//  SPOK
//
//  Created by GoodDamn on 06/04/2024.
//

import StoreKit

final class ExternalPurchaseLinkCompat {
    
    private static let URL_PURCHASE_LINK = URL(
        string: "https://spokapp.com/pay"
    )!
    
    static func open() {
        
        if #available(iOS 15.4, *) {
            openApi15_4()
            return
        }
        
        UIApplication
            .shared
            .open(
                URL_PURCHASE_LINK
            )
    }
    
    @available(iOS 15.4, *)
    private static func openApi15_4() {
        Task {
            do {
                try await ExternalPurchaseLink
                    .open()
            } catch {
                print(
                    "startShitPayment: ERROR:",
                    error
                )
            }
        }
    }
    
}
