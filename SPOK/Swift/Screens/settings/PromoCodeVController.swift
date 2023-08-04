//
//  AboutAppVController.swift
//  SPOK
//
//  Created by Cell on 25.12.2021.
//

import UIKit;
class PromoCodeVController:UIViewController{
    
    @IBOutlet weak var b_activate: UIButton!;
    @IBOutlet weak var tf_promo: UITextField!;
    
    @objc func hideSoftKeyboard(){
        view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSoftKeyboard)));
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-ExtraBold", size: 28) ?? UIFont.systemFont(ofSize: 28)];
        
        b_activate.layer.cornerRadius = b_activate.frame.height/2;
        b_activate.layer.shadowRadius = 10;
        b_activate.layer.shadowOpacity = 1;
        b_activate.layer.shadowOffset = CGSize(width: 0, height: 3);
        b_activate.layer.shadowColor = UIColor.black.cgColor;
        b_activate.layer.shouldRasterize = true;
        b_activate.layer.masksToBounds = true;
    }
    
}
