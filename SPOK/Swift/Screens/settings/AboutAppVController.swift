//
//  AboutAppVController.swift
//  SPOK
//
//  Created by Cell on 25.12.2021.
//

import UIKit;
class AboutAppVController:UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!;
    @IBOutlet weak var tv_terms: UITextView!;
    @IBOutlet weak var tv_tracks: UITextView!;
    @IBOutlet weak var contentHeight: NSLayoutConstraint!;
    @IBOutlet weak var tv_apache: UITextView!;
    
    @IBOutlet weak var bubble1: Bubble!;
    @IBOutlet weak var bubble2: Bubble!;
    @IBOutlet weak var bubble3: Bubble!;
    @IBOutlet weak var bubble4: Bubble!;
    @IBOutlet weak var mountain: UIImageView!;
    @IBOutlet weak var mountain2: UIImageView!;
    @IBOutlet weak var mountain3: UIImageView!;
    
    override func viewWillAppear(_ animated: Bool) {
        AnimationConstants.startTransitionBubble(v: bubble1, delay: 0.5);
        AnimationConstants.startTransitionBubble(v: bubble2, delay: 4.8);
        AnimationConstants.startTransitionBubble(v: bubble3, delay: 2.5);
        AnimationConstants.startTransitionBubble(v: bubble4, delay: 5.9);
        
        AnimationConstants.animateMountain(mountain, delay: 0.0);
        AnimationConstants.animateMountain(mountain2, delay: 2.3);
        AnimationConstants.animateMountain(mountain3, delay: 1.5);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        Utils.Design.barButton(navigationController, Utils.getLocalizedString("settings"));
        
        print("AboutApp_viewDidLoad():", contentHeight.constant, scrollView.contentSize.height);
        //contentHeight.constant = scrollView.contentSize.height;
        
        tv_apache.text = Utils.getLocalizedString("theApp");
        tv_tracks.text = Utils.getLocalizedString("theFollow");
        tv_terms.text = Utils.getLocalizedString("terms");
        
        let text = tv_apache.text!;
        
        let locate = text.distance(from: text.startIndex, to: text.firstIndex(of: "A")!);
        
        let attr = NSMutableAttributedString(string: text);
        
        attr.addAttributes([
        NSAttributedString.Key.foregroundColor: tv_apache.textColor!,
        NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: tv_apache.font!.pointSize)!],
                           range: NSRange(location: 0, length: text.count));
        
        attr.addAttribute(.link, value: "a", range: NSRange(location: locate, length: text.count-locate));
        
        tv_apache.attributedText = attr;
        tv_apache.linkTextAttributes = [NSAttributedString.Key.font:UIFont(name: "OpenSans-Bold", size: tv_apache.font!.pointSize)!,
            NSAttributedString.Key.foregroundColor: UIColor(named: "AccentColor")!,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue];
        
        tv_apache.delegate = self;
        
        Utils.setPrivacyAndTerms(tv_terms: tv_terms, textColour: UIColor(named: "privacy_color")!);
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if (URL.absoluteString=="a"){
            let vc = UIStoryboard(name: "mainMenu", bundle: Bundle.main).instantiateViewController(withIdentifier: "Apache") as! Apache;
            
            navigationController!.pushViewController(vc, animated: true);
        }
        return true;
    }

}
