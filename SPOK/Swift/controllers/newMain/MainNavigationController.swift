//
//  MainNavigationController.swift
//  SPOK
//
//  Created by Igor Alexandrov on 06.07.2022.
//

import UIKit;

class MainNavigationController
    : UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad();
        title = "";
        modalPresentationStyle = .overFullScreen;
        
        setNavigationBarHidden(
            true,
            animated: false
        )
        
        navigationBar.isTranslucent = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
