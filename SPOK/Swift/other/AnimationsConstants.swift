//
//  AnimationsConstants.swift
//  SPOK
//
//  Created by Cell on 13.04.2022.
//

import UIKit;

class AnimationConstants{
    
    static func startTransitionBubble (v:UIView,delay:TimeInterval)->Void{
        v.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        let p:CGFloat = v.frame.origin.y;
        UIView.animate(withDuration: 7.0, delay: delay, options: [.repeat], animations: {
            v.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            v.frame.origin.y -= 55;
        }, completion: {
            (b) in
            v.frame.origin.y = p;
        });
    }
    
    static func animateLabel(with label:UILabel,from:CGPoint, delay:TimeInterval, duration:TimeInterval)->Void{
        label.transform = CGAffineTransform(translationX: from.x, y: from.y);
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            label.transform = CGAffineTransform(translationX: 0.0, y: 0.0);
            label.alpha = 1.0;
        }, completion: nil);
    }
    
    static func animateMountain(_ v:UIImageView, delay:TimeInterval)->Void{
        v.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        let p:CGFloat = v.frame.origin.y;
        UIView.animate(withDuration: 1.5, delay: delay, options: [.transitionFlipFromRight], animations: {
            v.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
        }, completion: {
            (b) in
            UIView.animate(withDuration: 0.2, animations: {
                v.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
        });
    }
}
