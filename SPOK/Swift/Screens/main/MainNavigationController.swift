//
//  MainNavigationController.swift
//  SPOK
//
//  Created by Igor Alexandrov on 06.07.2022.
//

import UIKit;

class MainNavigationController: UINavigationController{
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        //self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.navigationController?.title = "";
        //self.navigationController?.navigationBar.isTranslucent = true;
        modalPresentationStyle = .overFullScreen;
        super.viewDidLoad();
    }
    
}
