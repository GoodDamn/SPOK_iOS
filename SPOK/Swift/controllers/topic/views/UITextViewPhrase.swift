//
//  UITextViewPhrase.swift
//  SPOK
//
//  Created by Cell on 31.12.2022.
//

import UIKit;

class UITextViewPhrase
    : UILabel {
    
    init(
        frame: CGRect,
        _ text: String
    ) {
        super.init(frame: frame);
        self.text = text;
        backgroundColor = .clear;
        isUserInteractionEnabled = false
        textAlignment = .center;
        numberOfLines = 0
        alpha = 0.0;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    deinit{
        print("UITextViewPhrase: deinit()")
    }
    
    public func show() {
        let h = sizeThatFits(
            CGSize(
                width: frame.width,
                height: CGFloat
                    .greatestFiniteMagnitude
            )
        ).height
        
        frame.size.height = h
        
        UIView.animate(
            withDuration: TimeInterval
                .random(in: 0.3..<1.0),
            delay: 0.35
        ) {
            self.alpha = 1.0
        }
    }
    
    public func hide(
        _ maxValY: CGFloat,
        _ completion: (()->Void)? = nil
    ) {
        UIView.animate(
            withDuration: 2.0,
            animations: {
                self.transform = CGAffineTransform(
                    translationX: 0,
                    y: maxValY
                );
                self.alpha = 0.0;
        }) { b in
            self.removeFromSuperview();
            completion?()
        }
    }
    
}
