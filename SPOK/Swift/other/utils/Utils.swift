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
    
    /*static func configLikes(
        _ controller: UIViewController,
        _ cell: UICollectionViewCell,
        id: Int,
        selectors: [Selector]
    ) {
        let gesture = UITapGestureRecognizer(
            target: controller,
            action: selectors[0]
        
        )
        gesture.numberOfTapsRequired = 1
        gesture.name = id.description
        cell.addGestureRecognizer(gesture)
        
        let double = UITapGestureRecognizer(
            target: controller,
            action: selectors[1]
        )
        double.numberOfTapsRequired = 2
        double.name = id.description
        cell.addGestureRecognizer(double)
        
        gesture.require(
            toFail: double
        )
        
    }*/

    
    
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
