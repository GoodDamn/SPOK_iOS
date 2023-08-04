//
//  Intro2ViewController.swift
//  SPOK
//
//  Created by Cell on 21.03.2022.
//

import UIKit;

class Intro2ViewController: UIViewController{
    
    @IBOutlet weak var musicNote: UIImageView!;
    @IBOutlet weak var l_weMixed: UILabel!;
    @IBOutlet weak var l_soYou: UILabel!;
    
    @IBOutlet weak var bubble1: Bubble!;
    @IBOutlet weak var bubble2: Bubble!;
    @IBOutlet weak var bubble3: Bubble!;
    @IBOutlet weak var bubble4: Bubble!;
    @IBOutlet weak var mountain: UIImageView!;
    @IBOutlet weak var mountain2: UIImageView!;
    @IBOutlet weak var mountain3: UIImageView!;
    
    @IBOutlet weak var b_open: UIButton!;
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    @IBAction func openSignIn(_ sender: UIButton) {
        b_open.isEnabled = false;
        let window = UIApplication.shared.windows[0];
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn") as! SignInViewController;
        UIView.transition(from: view, to: vc.view, duration: 1.0, options: [.transitionCrossDissolve], completion: {
            (b) in
            window.rootViewController = vc;
            UserDefaults().setValue(true, forKey: "intro");
        });
    }
    
    private func boldText(_ label:UILabel)->Void{
        let text = label.text!
        let attr = NSMutableAttributedString(string: text);
        let beginPos = text.distance(from: text.startIndex, to: text.firstIndex(of: "\n")!);
        attr.addAttribute(.font, value: UIFont(name: "OpenSans-Bold", size: label.font.pointSize)!, range: NSRange(location: beginPos, length: text.count-beginPos));
        label.attributedText = attr;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        musicNote.image?.withAlignmentRectInsets(UIEdgeInsets(top: -25, left: -25, bottom: -25, right: -25));
        //Constants.scaleFont(l_weMixed,increaseSize: 0);
        //Constants.scaleFont(l_soYou,increaseSize: 0);
        
        boldText(l_soYou);
        boldText(l_weMixed);
        
        AnimationConstants.startTransitionBubble(v: bubble1, delay: 0.5);
        AnimationConstants.startTransitionBubble(v: bubble2, delay: 4.8);
        AnimationConstants.startTransitionBubble(v: bubble3, delay: 2.5);
        AnimationConstants.startTransitionBubble(v: bubble4, delay: 5.9);
        
        AnimationConstants.animateMountain(mountain, delay: 0.0);
        AnimationConstants.animateMountain(mountain2, delay: 2.3);
        AnimationConstants.animateMountain(mountain3, delay: 1.5);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnimationConstants.animateLabel(with: l_weMixed, from: CGPoint(x: 160.0, y: 0.0), delay: 1.5, duration: 1.5);
        AnimationConstants.animateLabel(with: l_soYou, from: CGPoint(x: -160.0, y: 0.0), delay: 1.6, duration: 1.4);
    }
}
