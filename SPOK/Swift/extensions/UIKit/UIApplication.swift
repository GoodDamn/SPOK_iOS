//
//  UIApplication.swift
//  SPOK
//
//  Created by GoodDamn on 19/09/2024.
//

import Foundation
import UIKit.UIApplication
import StoreKit.SKStoreProductViewController

extension UIApplication {
    
    static func insets() -> UIEdgeInsets {
        shared
            .windows
            .first?
            .safeAreaInsets
        ?? .zero
    }
    
    static func mainNav() -> MainNavigationController {
        shared
            .windows
            .first?
            .rootViewController
        as! MainNavigationController
    }
    
    static func main() -> SKViewControllerMain {
        mainNav()
            .viewControllers
            .first
        as! SKViewControllerMain
    }
    
    static func openUrl(
        url: String
    ) {
        guard let url = URL(
            string: url
        ) else {
            return
        }
                
        shared.open(
            url
        )
    }
    
    static func openSettings() {
        guard let settings = NSURL(
            string: UIApplication
                .openSettingsURLString
        ) else {
            return
        }
        
        UIApplication.shared.open(
            settings as URL,
            options: [:],
            completionHandler: nil
        )
        
    }
    
    static func openAppStorePage() {
        let store = SKStoreProductViewController()
        
        store.loadProduct(
            withParameters: [
                SKStoreProductParameterITunesItemIdentifier: NSNumber(
                    value: 6443976042
                )
            ]
        )
        
        main().present(
            store,
            animated: true
        )
    }
}
