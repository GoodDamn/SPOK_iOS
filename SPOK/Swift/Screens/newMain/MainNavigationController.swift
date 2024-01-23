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
        navigationController?.title = "";
        modalPresentationStyle = .overFullScreen;
        
        navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
