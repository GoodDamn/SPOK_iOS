//
//  UITextViewPhrase.swift
//  SPOK
//
//  Created by Cell on 31.12.2022.
//

import UIKit;

final class UITextViewPhrase
    : UILabela {
    
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
        lineHeight = 0.83
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    deinit{
        print("UITextViewPhrase: deinit()")
    }
    
    public final func show() {
        animate(
            animations: { [weak self] in
                self?.alpha = 1.0
            }
        )
    }
    
    public final func hide(
        _ maxValY: CGFloat,
        _ completion: (()->Void)? = nil
    ) {
        
        animate(
            animations: { [weak self] in
                
                self?.transform = CGAffineTransform(
                    translationX: 0,
                    y: maxValY
                )
                
                self?.alpha = 0.0
            }
        ) { _ in
            self.removeFromSuperview();
            completion?()
        }
        
    }
    
}
