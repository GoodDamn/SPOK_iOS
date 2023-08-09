//
//  TabBarController.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit;

class TabBarController : UITabBarController,
                         UITabBarControllerDelegate {
    
    var manager: ManagerViewController? = nil;
    var prevIndex: Int = 0;
    var profile: ProfileViewController? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.delegate = self;
        manager = Utils.getManager();
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        manager?.pageViewController?.setViewControllers([manager!.viewControllersPages[tabBarController.selectedIndex]], direction: tabBarController.selectedIndex > prevIndex ? .forward : .reverse, animated: true, completion: nil);
        
        if tabBarController.selectedIndex == 2 {
            if profile == nil{
                profile = (manager?.viewControllersPages[2] as! UINavigationController).viewControllers.first! as! ProfileViewController;
            }
            profile?.updateHistory();
            profile?.updateLikes();
        }
        prevIndex = tabBarController.selectedIndex;
    }
}
