//
//  NoInternetViewController.swift
//  SPOK
//
//  Created by Igor Alexandrov on 18.07.2022.
//

import UIKit;

class NoInternetViewController: UIViewController{
    
    @IBOutlet weak var b_ok:UIButton!;
    @IBOutlet weak var v:UIView!;
    
    public var cell:SCellCollectionView? = nil;
    
    
    
    private func hide(){
        print("123456NoInternet: pressed");
        let manager = Utils.getManager();
        UIView.animate(withDuration: 0.23, animations: {
            self.v.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
            manager?.blurView.alpha = 0.0;
        }, completion:  {
            b in
            UIView.animate(withDuration: 0.14,
                           animations: {
                self.cell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                self.cell?.layer.shadowOpacity = 0.0;
            });
            manager?.closeFragment();
        });
    }
    
    @IBAction func close(_ sender: UIButton){
        hide();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        Utils.Design.roundedButton(b_ok);
        b_ok.contentEdgeInsets = UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25);
        v.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        v.alpha = 1.0;
        UIView.animate(withDuration: 0.23, animations: {
            self.v.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        });
        
        v.layer.cornerRadius = v.bounds.height/10;
        v.layer.shadowRadius = 15;
        v.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor;
        v.layer.shadowOpacity = 0.7;
        
        b_ok.isUserInteractionEnabled = true;
        v.isUserInteractionEnabled = true;
        view.isUserInteractionEnabled = true;
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.hide();
        });
    }
}
