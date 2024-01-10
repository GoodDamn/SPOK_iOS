//
//  SimplePageViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class SimplePageViewController
    : UIPageViewController {
    
    var source: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
    }
    
}


extension SimplePageViewController
    : UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let i = source.firstIndex(of: viewController
        ), i > 0 else {
            return nil
        }
        
        let before = i - 1
        
        return source[before]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let i = source.firstIndex(of: viewController
        ), i < (source.count - 1) else {
            return nil
        }
        
        let after = i + 1
        return source[after]
    }
    
}

extension SimplePageViewController
    : UIPageViewControllerDataSource {
    
    
    
}
