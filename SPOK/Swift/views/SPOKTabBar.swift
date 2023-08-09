//
//  SPOKTabBar.swift
//  SPOK
//
//  Created by GoodDamn on 08/08/2023.
//

import UIKit;

class BottomNavigationBar: UIView {
    
    private let TAG = "BottomNavigationBar";
    
    public func center_horizontal() {
        
        let c = subviews.count;
        let middle = c / 2;
        
        let offsetH = c % 2 == 0 ? 0 : subviews[middle].frame.width / 2;
        
        let midX = frame.width / 2;
        
        var leftOffset = offsetH;
        var rightOffset = offsetH;
        
        let b = subviews[middle].frame;
        
        subviews[middle].frame = CGRect(origin: CGPoint(x: midX-offsetH,
                                                        y: b.origin.y),
                                        size: b.size);
        
        for i in 1...middle {
            
            let vl = subviews[middle-i];
            let vr = subviews[middle+i];
            
            let bl = vl.frame;
            let br = vr.frame;
            
            vl.frame = CGRect(origin: CGPoint(x: midX-bl.size.width-leftOffset,
                                              y: bl.origin.y),
                              size: bl.size) // left side
            vr.frame = CGRect(origin: CGPoint(x: midX+rightOffset,
                                              y: br.origin.y),
                              size: br.size); // right side
            
            leftOffset += bl.size.width;
            rightOffset += br.size.width;
        }
    }
    
    public func center_vertical() {
        for view in subviews {
            let b = view.bounds;
            let insetV = (frame.height - view.frame.height) / 2;
            print(TAG,"center_vertical:",b,"navFrame:",frame,"viewFrame:",view.frame);
            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: insetV),
                                 size: b.size);
        }
    }
    
    public func addTab(_ tab: UIImageView) {
        addSubview(tab);
    }
    
}
