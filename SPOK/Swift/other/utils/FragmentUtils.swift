//
//  FragmentUtils.swift
//  SPOK
//
//  Created by GoodDamn on 18/06/2024.
//

import Foundation
import UIKit.UIApplication

final class FragmentUtils {
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
