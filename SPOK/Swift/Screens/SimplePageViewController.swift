//
//  SimplePageViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

public class SimplePageViewController
    : UIPageViewController {
    
    private final let TAG = "SimplePageViewController"
    
    private var mPrevIndex = 0
    
    var withGesture: Bool = true {
        didSet {
            dataSource = withGesture ?
                self
              : nil
        }
    }
    
    var source: [UIViewController] = [] {
        didSet {
            
            var i = 0
            for vc in source {
                vc.view.tag = i
                i += 1
            }
            
            setViewControllers(
                [source[0]],
                direction: .forward,
                animated: true,
                completion: nil
            );
        }
    }
    
    public var mIndex: Int = 0 {
        didSet {
            setViewControllers(
                [source[mIndex]],
                direction: mIndex > mPrevIndex ? .forward
                  : .reverse,
                animated: true
            ) { b in
                self.mPrevIndex = self.mIndex
            }
            onNewPage?(mIndex)
        }
    }
    
    var onNewPage: ((Int)->Void)? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
    }
    
}


extension SimplePageViewController
    : UIPageViewControllerDelegate {
    
    
    public func pageViewController(
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
    
    public func pageViewController(
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
    
    public func pageViewController(
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
