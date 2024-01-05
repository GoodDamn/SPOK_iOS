//
//  BannerViewController.swift
//  SPOK
//
//  Created by GoodDamn on 20/07/2023.
//

import UIKit;
import FirebaseDatabase;

class BannerViewController: UIViewController {
    
    @IBOutlet weak var mLabelTechReasons: UILabel!;
    @IBOutlet weak var mLabelFetures: UILabel!;
    @IBOutlet weak var mLabelFeature1: UILabel!;
    @IBOutlet weak var mLabelFeature2: UILabel!;
    @IBOutlet weak var mLabelFeature3: UILabel!;
    @IBOutlet weak var mLabelfixTech: UILabel!;
    
    @IBOutlet weak var mTextViewNotify: UITextView!;
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    private func stat(property: String) {
        Database
            .database()
            .reference(withPath: "Stats/iOS/"+property)
            .setValue(ServerValue.increment(1));
    }
    
    @IBAction func popViewController(_ sender: Any) {
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func popViewControllerButton(_ sender: Any) {
        stat(property: "goBtn");
        navigationController?.popViewController(animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        modalPresentationStyle = .fullScreen;
        
        let color = UIColor(
            named: "background"
        )
        
        view.subviews[0]
            .subviews[0]
            .backgroundColor = color
        
        stat(property: "enter");
        
        mTextViewNotify.text = Utils.getLocalizedString("notifyUs");
        mLabelFetures.text = Utils.getLocalizedString("features");
        mLabelfixTech.text = Utils.getLocalizedString("fixTech");
        mLabelFeature1.text = Utils.getLocalizedString("feature1");
        mLabelFeature2.text = Utils.getLocalizedString("feature2");
        mLabelFeature3.text = Utils.getLocalizedString("feature3");
        mLabelTechReasons.text = Utils.getLocalizedString("techReasons");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let l = mTextViewNotify.text.count;
        
        let textColor = mTextViewNotify
                .textColor?
                .withAlphaComponent(0.6)
                .cgColor;
        
        let st = Utils
            .getLocalizedString("asd");
        
        let attr = NSMutableAttributedString(
            string: mTextViewNotify
                .text!
        );
        
        let styleCenteredText = NSMutableParagraphStyle();
        styleCenteredText.alignment = .center;
        
        attr.addAttributes([
                NSAttributedString
                    .Key.foregroundColor: mTextViewNotify.textColor!,
                NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: mTextViewNotify.font!.pointSize)!,
                NSAttributedString.Key.paragraphStyle: styleCenteredText],
                range: NSRange(location: 0, length: l));
        
        attr.addAttribute(.link, value: "c", range: NSRange(location: l-st.count, length: st.count));
        
        mTextViewNotify.attributedText = attr;
        mTextViewNotify.linkTextAttributes = [
            NSAttributedString
                .Key
                .font: UIFont(
                    name: "OpenSans-SemiBold",
                    size: mTextViewNotify
                        .font!
                        .pointSize
                )!,
            NSAttributedString
                .Key.foregroundColor:
                    mTextViewNotify
                    .textColor!,
             NSAttributedString
                .Key
                .underlineStyle: NSUnderlineStyle
                    .single
                    .rawValue
        ];
        
        mTextViewNotify.delegate = self;
    }
    
}

extension BannerViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if (url.absoluteString != "c") {
            return false;
        }
        
        stat(property: "clickMe");
        print("notifyUs:");
        Toast.init(text: Utils.getLocalizedString("letUsKnow"), duration: 1.8).show();
        navigationController?.popViewController(animated: true);
        
        return true;
    }
    
}
