//
//  SeekBar.swift
//  SPOK
//
//  Created by Cell on 30.12.2021.
//

import UIKit;
@IBDesignable
class SeekBar:UISlider{
    
    @IBInspectable var thumbImage:UIImage?{
        didSet{
            setThumbImage(thumbImage, for: .normal);
        }
    };
    
    @IBInspectable var highlightImage:UIImage?{
        didSet{
            setThumbImage(thumbImage, for: .highlighted);
        }
    };
    
    public var vectorImage:CALayer?{
        didSet{
            setNeedsDisplay();
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame);
        let viewFromXib = Bundle.main.loadNibNamed("SeekBar", owner: self, options: nil)![0] as! UIView;
        viewFromXib.frame = self.bounds;
        addSubview(viewFromXib);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override func draw(_ rect: CGRect) {
        if (vectorImage != nil){
            print("vectorImage");
            UIGraphicsBeginImageContextWithOptions(vectorImage!.frame.size, vectorImage!.isOpaque, 1.0);
            
            vectorImage?.render(in: UIGraphicsGetCurrentContext()!);
            
            setThumbImage(UIGraphicsGetImageFromCurrentImageContext(), for: .normal);
            setThumbImage(UIGraphicsGetImageFromCurrentImageContext(), for: .highlighted);
            
            UIGraphicsEndImageContext();
        }
    }
}
