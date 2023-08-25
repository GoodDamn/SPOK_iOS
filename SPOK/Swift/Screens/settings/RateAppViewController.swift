//
//  RateAppViewController.swift
//  SPOK
//
//  Created by Cell on 27.12.2021.
//

import UIKit;
import StoreKit;

class RateAppViewController:UIViewController{
    
    @IBOutlet weak var arcProgressBar:ArcProgressBar!;
    @IBOutlet weak var slider: UISlider!;
    @IBOutlet weak var b_rate: UIButton!;
    @IBOutlet weak var star1: Star!;
    @IBOutlet weak var star2:Star!;
    @IBOutlet weak var star3: Star!;
    @IBOutlet weak var star4:Star!;
    @IBOutlet weak var star5: Star!;
    @IBOutlet weak var radialGrad:UIView!;
    
    private let tag = "RateAppViewController:";
    
    override func viewWillAppear(_ animated: Bool) {
        print(tag, "viewWillAppear");
        slider.value = 0.0;
        slider.sendActions(for: .valueChanged);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        b_rate.layer.cornerRadius = b_rate.layer.frame.height/2;
        
        b_rate.layer.shadowRadius = 15;
        b_rate.layer.shadowOpacity = 1.0;
        b_rate.layer.shadowColor = UIColor.black.cgColor;
        b_rate.layer.shadowOffset = CGSize(width: 0, height: 0);
        b_rate.layer.masksToBounds = true;
        
        
        let grad = CAGradientLayer();
        grad.type = .radial;
        grad.frame = radialGrad.bounds;
        grad.colors = [UIColor.yellow.cgColor,
                       UIColor(named: "background")!.cgColor];
        grad.startPoint = CGPoint(x: 0.475, y: 0.5);
        grad.endPoint = CGPoint(x: 1.0, y: 1.0);
        radialGrad.alpha = 0.0;
        radialGrad.layer.addSublayer(grad);
        
        print(tag, UIScreen.main.bounds, radialGrad.bounds);
        
        Utils.Design.barButton(navigationController, Utils.getLocalizedString("settings"));
    }
    
    private var isEnabled:Bool = false;
    private var toast:Toast = Toast.init(text: Utils.getLocalizedString("plRate"), duration: 1.0);
    
    @IBAction func nextScreen(_ sender: UIButton){
        if (arcProgressBar.progress > 10 && arcProgressBar.progress<170){
            let feedBack = storyboard!.instantiateViewController(withIdentifier: "feedback") as! FeedBackViewController;
            feedBack.grade = ((arcProgressBar.progress/36.0)*10).rounded(.down)/10;
            print("nextScreen: ", feedBack.grade);
            feedBack.onViewDisappear = {
                self.navigationController?.setNavigationBarHidden(false, animated: true);
            }
            navigationController?.pushViewController(feedBack, animated: true);
            return;
        }
        
        if (!isEnabled){
            toast.show();
            return;
        }
        
        let vc = SKStoreProductViewController();
        vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: 6443976042)], completionBlock: nil);
        present(vc, animated: true, completion: nil);
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        print(tag,"valueChanged:",sender.value);
        
        let p:CGFloat = CGFloat(sender.value/slider.maximumValue);
        radialGrad.alpha = p;
        arcProgressBar.progress = sender.value;
        star1.progress = sender.value;
        star2.progress = sender.value;
        star3.progress = sender.value;
        star4.progress = sender.value;
        star5.progress = sender.value;
        
        if (isEnabled && sender.value < 10){
            isEnabled = false;
            UIView.animate(withDuration: 0.3, animations: {
                self.b_rate.alpha = 0.7;
            });
            return;
        }
        
        if (!isEnabled && sender.value > 10){
            UIView.animate(withDuration: 0.3, animations: {
                self.b_rate.alpha = 1.0;
            });
            isEnabled = true;
        }
        
        
    }
}
