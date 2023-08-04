//
//  TechWorksViewController.swift
//  SPOK
//
//  Created by Cell on 07.03.2022.
//

import UIKit;
import FirebaseDatabase;

class TechWorksViewController: UIViewController {
    
    class Recognizer: UIGestureRecognizer {
        
        private var middleX:CGFloat = 162.5, middleY:CGFloat = 162.5;
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            self.view?.layer.removeAllAnimations();
            middleX = self.view!.bounds.width/2;
            middleY = self.view!.bounds.height/2;
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
            if let touch = touches.first{
                let pos = touch.location(in: self.view!);
                var x = pos.x, y = pos.y;
                var rotation:CGFloat;
                if (y < middleY){
                    x = middleX-x;
                    y = middleY-y;
                    let h = CGFloat(hypot(x, y));
                    if (pos.x < middleX) {
                        rotation = y/h*90;
                    } else {
                        rotation = x/h * -90+90;
                    }
                } else {
                    if (x > middleX){
                        x-=middleX;
                        let h = CGFloat(hypot(x, y-middleY));
                        rotation = (x/h-1.0) * -90+180;
                    } else {
                        y-=middleY;
                        let h = CGFloat(hypot(middleX-x, y));
                        rotation = y/h * -90 + 360;
                    }
                }
                self.view?.transform = CGAffineTransform(rotationAngle: .pi * rotation/180);
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            UIView.animate(withDuration: 3.0, animations: {
                self.view!.transform = CGAffineTransform(rotationAngle: 0);
            }, completion: {
                (b) in
                let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z");
                rotation.duration = 240.0;
                rotation.fromValue = 0.0;
                rotation.toValue = Double.pi * 8;
                rotation.repeatCount = .infinity;
                self.view?.layer.add(rotation, forKey: "rotation");
            });
        }
    }
    
    private func startRotation(view:UIView?, to:CGFloat) -> Void{
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z");
        rotation.duration = 240.0;
        rotation.fromValue = 0.0;
        rotation.toValue = to;
        rotation.repeatCount = .infinity;
        view?.layer.add(rotation, forKey: "rotation");
    }
    
    
    @IBOutlet weak var gearR: UIImageView!;
    @IBOutlet weak var gearL: UIImageView!;
    @IBOutlet weak var gearSL: UIImageView!;
    @IBOutlet weak var gearSR: UIImageView!;
    
    @IBOutlet weak var b_update: UIButton!;
    
    @IBOutlet weak var bubble: Bubble!;
    @IBOutlet weak var bubble2: Bubble!;
    @IBOutlet weak var bubble3: Bubble!;
    @IBOutlet weak var bubble4: Bubble!;
    @IBOutlet weak var bubble5: Bubble!;
    @IBOutlet weak var bubble6: Bubble!;
    
    @IBOutlet weak var boil: UIImageView!;
    
    @IBAction func tryAgain(_ sender: UIButton) {
        
        Database.database().reference(withPath: "state").observeSingleEvent(of: .value, with: {
            snapshot in
            if let state = snapshot.value as? Int{
                if state == 1{ // Check state of server
                    self.navigationController?.popViewController(animated: true);
                } else {
                    Toast.init(text: "Techical works", duration: 2.8).show();
                }
            }
        });
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        
        b_update.layer.cornerRadius = b_update.bounds.height/2;
        
        b_update.layer.shadowColor = UIColor(named: "AccentColor")!.cgColor;
        b_update.layer.shadowOpacity=0.2;
        b_update.layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        b_update.layer.shadowRadius = 4;
        b_update.layer.shouldRasterize = true;
        startRotation(view: gearR,to: .pi * 8);
        startRotation(view: gearL,to: .pi * -8);
        
        startRotation(view: gearSL,to: .pi * 8);
        startRotation(view: gearSR,to: .pi * -8);
        
        AnimationConstants.startTransitionBubble(v: bubble, delay: 0.0);
        AnimationConstants.startTransitionBubble(v: bubble2, delay: 3.5);
        AnimationConstants.startTransitionBubble(v: bubble3, delay: 2.5);
        AnimationConstants.startTransitionBubble(v: bubble4, delay: 0.5);
        AnimationConstants.startTransitionBubble(v: bubble5, delay: 4.5);
        AnimationConstants.startTransitionBubble(v: bubble6, delay: 6.0)
        
        gearR.addGestureRecognizer(Recognizer());
        gearL.addGestureRecognizer(Recognizer());
    }
    
}
