//
//  UITextViewPhrase.swift
//  SPOK
//
//  Created by Cell on 31.12.2022.
//

import UIKit;

class UITextViewPhrase: UITextView{
    
    public func initial(t:String?){
        text = t;
        font = UIFont(name: "RoundedMplus1c-Light", size: 19.0);
        textColor = UIColor(named: "text_topic");
        backgroundColor = .clear;
        isEditable = false;
        isSelectable = false;
        textAlignment = .center;
        alpha = 0.0;
    }
    
    public func show() {
        UIView.animate(withDuration: TimeInterval.random(in: 0.3..<1.0),delay: 0.35,animations: {
            self.alpha = 1.0;
        });
    }
    
    public func hide(_ maxValY: CGFloat) {
        let y = contentSize.height + CGFloat.random(in: 0..<maxValY);
        
        UIView.animate(withDuration: Double(y)/80, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: y);
            self.alpha = 0.0;
        }, completion: {
            b in
            self.removeFromSuperview();
        });
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame,textContainer: textContainer);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}
