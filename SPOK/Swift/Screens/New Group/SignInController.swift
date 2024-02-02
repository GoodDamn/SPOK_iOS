//
//  ViewController.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit;

class SignInViewController
    : StackViewController {
    
    private weak var mBtnApple: UIButton!;
    private weak var mTextViewPrivacy: UITextView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    
    @objc private func closeScreen(
        _ v: UIButton
    ) {

    }
    
    
    @objc private func loginApple(
        _ sender: UIButton
    ) {
        print("Apple auth is started");
        
        
    }
    
    
}


