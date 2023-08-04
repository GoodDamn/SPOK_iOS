//
//  Toast.swift
//  SPOK
//
//  Created by Cell on 15.12.2021.
//

import Foundation;
import UIKit;

class Toast{
    
    private var isShowing:Bool;
    private var text:String;
    private var duration:Double;
    
    init(text:String, duration:Double){
        self.text = text;
        self.duration = duration;
        isShowing = false;
    }
    
    public func setText(text:String)->Toast{
        self.text = text;
        return self;
    }
    
    public func setDuration(duration:Double)->Toast{
        self.duration = duration;
        return self;
    }
    
    public func show(){
        if (!isShowing){
            isShowing=true;
            guard let window = UIApplication.shared.keyWindow else {
                return;
            };
        
            let label = UILabel();
            label.text = text;
            label.textColor=UIColor.black;
            label.font=UIFont.systemFont(ofSize: 18);
            label.backgroundColor=UIColor.white;
            label.numberOfLines=4;
            label.textAlignment = .center;
        
            let textSize = label.intrinsicContentSize;
            let lwidth=min(textSize.width, window.frame.width-40);
            let lheight = (textSize.height/window.frame.height)*30;
        
            label.frame = CGRect(x: 20, y: window.frame.height, width: lwidth+30, height: max(lheight, textSize.height+20));
            label.center.x=window.center.x;
            label.layer.cornerRadius=15;
            label.layer.shadowOffset = CGSize(width: 0, height: 0);
            label.layer.shadowOpacity=1.0;
            label.layer.shadowRadius=8;
            label.layer.shouldRasterize=true;
            label.layer.rasterizationScale=UIScreen.main.scale;
            label.layer.masksToBounds=true;
            window.addSubview(label);
            
            UIView.animate(withDuration: 0.25, animations: {
                label.center.y = window.frame.height-90;
            }){ _ in ()
                DispatchQueue.main.asyncAfter(deadline: .now()+self.duration){
                    UIView.animate(withDuration:            0.25, animations:{
                        label.alpha=0;
                        label.center.y = window.frame.height;
                        }){ _ in ()
                        label.removeFromSuperview();
                        self.isShowing = false;
                    };
                }
            };
        }
    }
}
