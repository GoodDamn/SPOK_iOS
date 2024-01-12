//
//  MainPageViewController.swift
//  SPOK
//
//  Created by Cell on 01.08.2022.
//

import UIKit;

public class MainPageViewController
    : UIPageViewController {
       
    private var mPrevIndex = 0
    
    public var mPages: [UIViewController] = [] {
        didSet {
            setViewControllers(
                [mPages[0]],
                direction: .forward,
                animated: true,
                completion: nil
            );
        }
    }
    
    public var mIndex: Int = 0 {
        didSet {
            setViewControllers(
                [mPages[mIndex]],
                direction: mIndex > mPrevIndex ? .forward
                  : .reverse,
                animated: true
            ) { b in
                self.mPrevIndex = self.mIndex
            }
        }
    }
    
}
