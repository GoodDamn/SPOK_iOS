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
    
    private final let TAG = "SimplePageViewController"
    
    var source: [UIViewController] = [] {
        didSet {
            
            var i = 0
            
            for vc in source {
                
                vc.view.tag = i
                
                i += 1
            }
            
        }
    }
    
    var onNewPage: ((Int)->Void)? = nil
    
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
        
        print(TAG,"viewControllerBefore",i)
        
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
        
        print(TAG,"viewControllerAfter",i)
        
        let after = i + 1
        return source[after]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        
        onNewPage?(pageViewController
            .viewControllers!
            .first!
            .view
            .tag
        )
            
    }
    
}

extension SimplePageViewController
    : UIPageViewControllerDataSource {
    
    
    
}
