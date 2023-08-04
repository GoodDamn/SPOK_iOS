//
//  AdvancedLabel.swift
//  SPOK
//
//  Created by Cell on 03.03.2022.
//

import UIKit;

class AdvancedLabel: UIView {
    
    @IBOutlet weak var label: UILabel!;
    @IBOutlet weak var image: UIImageView!;
    
    @IBInspectable var text:String = ""{
        didSet{
            label.text = text;
            frame.size.height = label.bounds.height;
            setNeedsDisplay();
        }
    }
    
    @IBInspectable var font:UIFont = UIFont(){
        didSet{
            label.font = font;
            setNeedsDisplay();
        }
    }
    
    @IBInspectable var leftImage:UIImage = UIImage() {
        didSet {
            image.image = leftImage;
            /*let attachement = NSTextAttachment();
            attachement.image = leftImage;
            attachement.bounds = CGRect(x: 0, y: 0, width: 8, height: 8);
            let attr = NSMutableAttributedString();
            attr.append(NSAttributedString(attachment: attachement));
            
            let a = NSMutableAttributedString(string: label.text!);
            a.addAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 18.0)], range: NSRange(location: 0, length: label.text!.count));
            attr.append(a);
            label.attributedText = attr;*/
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        comInit();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        comInit();
    }

    func comInit() -> Void {
        addSubview(Bundle.main.loadNibNamed("AdvancedLabel", owner: self, options: nil)![0] as! UIView);
        
        label.textColor = tintColor;
        image.tintColor = tintColor;
    }
}
