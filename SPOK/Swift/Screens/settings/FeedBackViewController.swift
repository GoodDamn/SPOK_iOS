//
//  FeedBackViewController.swift
//  SPOK
//
// Created by Cell on 09.01.2022.
//

import UIKit;
import FirebaseDatabase;

class FeedBackViewController: UIViewController {

    private let tag = "FeedBackViewController";
    
    @IBOutlet weak var b_continue: UIButton!;
    @IBOutlet weak var tf_assess: UITextView!;
    @IBOutlet weak var l_title: UILabel!;
    @IBOutlet weak var l_description: UILabel!;
    
    var grade:Float = 0.0;
    
    var onViewDisappear:(()->Void)? = nil;
    var placeholder:String = Utils.getLocalizedString("assExample");
    var titleButton:String = Utils.getLocalizedString("continue");
    var pathToAssess:String = "assess/iOS/";
    var desc:String? = nil;
    
    @IBAction func close(){
        navigationController?.popViewController(animated: true);
    }
    
    @objc func hideSoftKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true);
    }
    
    @objc func sendAsses(_ sender: UIButton){
        
        print(self.tag, "sendAsses:",tf_assess.text);
        
        if (tf_assess.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            Toast.init(text: Utils.getLocalizedString("write"), duration: 1.2).show();
            return;
        }
        
        feedBack(" " + tf_assess.text);
        Toast.init(text: Utils.getLocalizedString("thankYou"), duration: 1.2).show();
        onViewDisappear?();
        navigationController?.popToRootViewController(animated: true);
    
    }
    
    private func checkText(_ textView:UITextView) {
        let s = textView.text.trimmingCharacters(in: .whitespacesAndNewlines);
        print(tag, "check text", s, s.isEmpty);
        if (s.isEmpty){
            textView.text = placeholder;
            textView.textColor = UIColor(named: "placeholder");
            b_continue.alpha = 0.7;
            return;
        }
        b_continue.alpha = 1.0;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(tag, "will Disappear");
        onViewDisappear?();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationController?.setNavigationBarHidden(true, animated: true);
        
        
        tf_assess.delegate = self;
        b_continue.layer.cornerRadius = b_continue.frame.height/3;
        b_continue.layer.masksToBounds = true;
        if desc != nil{
            l_description.text = desc;
        }
        
        if title != nil{
            l_title.text = title;
        }
        
        tf_assess.text = placeholder;
        
        b_continue.addTarget(self, action: #selector(sendAsses(_:)), for: .touchUpInside);
        b_continue.setTitle(titleButton, for: .normal);
        navigationItem.hidesBackButton = true;
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSoftKeyboard(_:))));
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
     
    
    private func feedBack(_ feedback:String = "") {
        let uuID = UIDevice.current.identifierForVendor?.uuidString ?? "NULL";
        let userID = UserDefaults().string(forKey: Utils.userRef) ?? uuID;
        
        Database
            .database()
            .reference(withPath: pathToAssess+userID)
            .setValue(grade.description + feedback);
    }
    
}


extension FeedBackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor(named: "placeholder")){
            textView.text = nil;
            textView.textColor = UIColor(named: "AccentColor");
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkText(textView);
    }
}
