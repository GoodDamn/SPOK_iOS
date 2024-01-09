//
//  SPOKTabBar.swift
//  SPOK
//
//  Created by GoodDamn on 08/08/2023.
//

import UIKit;

class BottomNavigationBar: UIView {
    
    private let TAG = "BottomNavigationBar";
    
    public var mTintColorSelected:UIColor? = .systemBlue;
    public var mOffset: CGFloat = 25.0;
    
    public var mOnSelectTab:((Int)->Void)? = nil;
    
    private var mCurrentIndex:Int = 0;
    
    public func center_horizontal() {
        
        let c = subviews.count;
        
        let middle = c / 2;
        
        if c % 2 == 0 {
            let midx = frame.width / 2
            // left
            var ll = midx - mOffset
            for i in 0..<middle {
                let r = subviews[i]
                    .frame
                
                subviews[i]
                    .frame = CGRect(
                        x: ll - r.width,
                        y: r.origin.y,
                        width: r.width,
                        height: r.height
                    )
                ll += mOffset
            }
            
            // right
            var rr = mOffset
            for i in middle..<c {
                let r = subviews[i]
                    .frame
                
                subviews[i]
                    .frame = CGRect(
                        x: midx+rr,
                        y: r.origin.y,
                        width: r.width,
                        height: r.height
                    )
                
                rr += r.width + mOffset
            }
            
            return
        }
        
        
        let offsetH = subviews[middle]
            .frame
            .width / 2;
        
        let midX = frame.width / 2;
        
        var leftOffset = offsetH+mOffset;
        var rightOffset = offsetH+mOffset;
        
        let b = subviews[middle].frame;
        
        subviews[middle].frame = CGRect(
            origin: CGPoint(
                x: midX-offsetH,
                y: b.origin.y),
            size: b.size);
        
        print(TAG, "MIDDLE:",middle)
        
        for i in 1...middle {
            
            let vl = subviews[middle-i];
            let vr = subviews[middle+i];
            
            let bl = vl.frame;
            let br = vr.frame;
            
            vl.frame = CGRect(
                origin: CGPoint(
                    x:midX-bl.size.width-leftOffset,
                    y: bl.origin.y
                ),
                size: bl.size
            ) // left side
            
            vr.frame = CGRect(
                origin: CGPoint(
                    x: midX+rightOffset,
                    y: br.origin.y
                ),
                size: br.size
            ); // right side
            
            leftOffset += bl.size.width;
            rightOffset += br.size.width;
        }
    }
    
    public func center_vertical() {
        for view in subviews {
            let b = view.bounds;
            let insetV = (frame.height - view.frame.height) / 2;
            print(TAG,"center_vertical:",b,"navFrame:",frame,"viewFrame:",view.frame);
            view.frame = CGRect(
                origin: CGPoint(
                    x: view.frame.origin.x,
                    y: insetV
                ), size: b.size);
        }
    }
    
    public func addTab(_ tab: UIButton) {
        tab.tag = subviews.count;
        tab.isUserInteractionEnabled = true;
        tab.addTarget(self, action: #selector(selectTab(_:)), for: .touchUpInside);
        addSubview(tab);
    }
    
    
    @objc func selectTab(_ sender: UIButton) {
        
        if sender.tag == mCurrentIndex {
            return;
        }
        
        print(self.TAG, "selectTab:",sender.tag);
        subviews[mCurrentIndex].tintColor = .lightGray;
        mCurrentIndex = sender.tag;
        sender.tintColor = mTintColorSelected;
        
        mOnSelectTab?(mCurrentIndex);
    }
}
