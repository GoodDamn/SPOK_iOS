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
    
    @IBOutlet weak var mTextViewNotify: SpanTextView!;
    
    private func stat(property: String) {
        let ref = Database.database().reference(withPath: "Stats/iOS/"+property);
        
        ref.observeSingleEvent(of: .value, with: {
            snapshot in
            var val = snapshot.value as? Int ?? 0;
            val += 1;
            ref.setValue(val);
        });
    }
    
    @IBAction func popViewController(_ sender: Any) {
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func popViewControllerButton(_ sender: Any) {
        stat(property: "goBtn");
        navigationController?.popViewController(animated: true);
    }
    
    @objc func notifyUs(_ sender: UITapGestureRecognizer) {
    
        stat(property: "banner");
        print("notifyUs:");
        Toast.init(text: Utils.getLocalizedString("letUsKnow"), duration: 1.8).show();
        popViewController(sender);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
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
        
        let st = Utils.getLocalizedString("asd");
        
        mTextViewNotify.addSpan(from: l-st.count,
                                to: l,
                                action: #selector(notifyUs(_:)),
                                target: self,
                                attrs:  [NSAttributedString.Key.font: mTextViewNotify.font,
                                         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
                                         NSAttributedString.Key.underlineColor: textColor,
                                         NSAttributedString.Key.foregroundColor: textColor,
                                         NSAttributedString.Key.backgroundColor: UIColor.clear]);
    }
    
}
