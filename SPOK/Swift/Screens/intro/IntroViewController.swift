//
//  IntroViewController.swift
//  SPOK
//
//  Created by Cell on 21.03.2022.
//

import UIKit;

class IntroViewController: UIViewController{
    
    @IBOutlet weak var l_welcome: UILabel!;
    @IBOutlet weak var l_forgetProbs: UILabel!;
    
    @IBOutlet weak var cocktail: UIImageView!;
    @IBOutlet weak var marshmallow: UIImageView!;
    @IBOutlet weak var sunbed: UIImageView!;
    @IBOutlet weak var umbrella: UIImageView!;
    @IBOutlet weak var sun: UIImageView!;
    @IBOutlet weak var b_next: UIButton!;
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //Constants.scaleFont(l_welcome, increaseSize:0);
        //Constants.scaleFont(l_forgetProbs, increaseSize:0);
        
        //umbrella.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0);
        
        let transf = CGAffineTransform(scaleX: 0.0, y: 0.0);
        sun.transform = transf;
        sunbed.transform = transf;
        umbrella.transform = transf;
        cocktail.transform = transf;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnimationConstants.animateLabel(with: l_welcome, from: CGPoint(x: 0.0, y: 160.0), delay: 2.7, duration: 0.8);
        AnimationConstants.animateLabel(with: l_forgetProbs, from: CGPoint(x: 0.0, y: -80.0), delay: 3.4, duration: 0.8);
        
        UIView.animate(withDuration: 1.5, delay: 1.2, options: [], animations: {
            self.sunbed.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        }, completion: {
            (b) in
            UIView.animate(withDuration: 0.8, animations: {
                self.marshmallow.transform = CGAffineTransform(rotationAngle: .pi * -0.0611);
            }, completion: {
                (b) in
                UIView.animate(withDuration: 1.4, animations: {
                    self.cocktail.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                }, completion: {
                    (b) in
                    UIView.animate(withDuration: 1.2, animations: {
                        self.umbrella.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                    }, completion: {
                        (b) in
                        UIView.animate(withDuration: 3.75, animations: {
                            self.umbrella.transform = CGAffineTransform(rotationAngle: .pi*0.019);
                        }, completion: {
                            (b) in
                            UIView.animate(withDuration: 7.5, delay: 0.0, options: [.repeat,.autoreverse], animations: {
                                self.umbrella.transform = CGAffineTransform(rotationAngle: .pi * -0.019);
                            }, completion: nil);
                        });
                    });
                });
            });
        });
        
        UIView.animate(withDuration: 1.2, animations: {
            self.sun.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            self.sun.transform = CGAffineTransform(rotationAngle: .pi);
        }, completion: {
            (b) in
            UIView.animate(withDuration: 95.0, delay: 0.0, options: [.repeat], animations: {
                self.sun.transform = CGAffineTransform(rotationAngle: .pi*4);
            }, completion: {(b) in
                self.sun.transform = CGAffineTransform(rotationAngle: 0);
            });
        });
        
    }
}
