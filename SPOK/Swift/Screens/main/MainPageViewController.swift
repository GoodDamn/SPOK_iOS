//
//  MainPageViewController.swift
//  SPOK
//
//  Created by Cell on 01.08.2022.
//

import UIKit;

class MainPageViewController: UIPageViewController{
       
    var manager: ManagerViewController? = nil;
    
    func setup(){
        manager = Utils.getManager();
        //manager?.pageViewController?.dataSource = self;
        setViewControllers(
            [manager!
                .viewControllersPages[0]
            ],
            direction: .forward,
            animated: true,
            completion: nil
        );
    }
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
    }
}
