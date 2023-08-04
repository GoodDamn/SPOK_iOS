//
//  MainPageViewController.swift
//  SPOK
//
//  Created by Cell on 01.08.2022.
//

import UIKit;

class MainPageViewController: UIPageViewController{
    
    var manager: ManagerViewController? = nil;
    
    /*func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = manager?.viewControllersPages.firstIndex(of: viewController as! UINavigationController) ?? 0;
        manager?.tabController?.selectedIndex = index;
        guard index > 0 else {
            return nil;
        }
        
        return manager?.viewControllersPages[index-1];
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = manager?.viewControllersPages.firstIndex(of: viewController as! UINavigationController) ?? 0;
        manager?.tabController?.selectedIndex = index;
        guard index < (manager!.viewControllersPages.count-1) else {
            return nil;
        }
        
        return manager?.viewControllersPages[index+1];
    }*/
    
    
    func setup(){
        manager = Utils.getManager();
        //manager?.pageViewController?.dataSource = self;
        setViewControllers([manager!.viewControllersPages[0]], direction: .forward, animated: true, completion: nil);
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
    }
}
