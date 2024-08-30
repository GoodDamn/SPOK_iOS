//
//  Constants.swift
//  SPOK
//
//  Created by Cell on 24.01.2022.
//

import UIKit;
import FirebaseDatabase;

final class Utils {
    
    private static let TAG = "Utils:";
    
    public static func mainNav(
    ) -> MainNavigationController {
        return UIApplication
            .shared
            .windows[0]
            .rootViewController
            as! MainNavigationController
    }
    
    public static func main(
    ) -> MainViewController {
        return mainNav()
            .viewControllers[0]
            as! MainViewController
    }
    
    public static func insets(
    ) -> UIEdgeInsets {
        return UIApplication
            .shared
            .windows
            .first?
            .safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    public static func openSettings() {
        
        guard let settings = NSURL(
            string: UIApplication
                .openSettingsURLString
        ) else {
            return
        }
        
        UIApplication
            .shared
            .open(
                settings as URL,
                options: [:],
                completionHandler: nil
            )
        
    }
 
}
