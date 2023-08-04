//
//  EditText.swift
//  SPOK
//
//  Created by Cell on 24.12.2021.
//

import UIKit;

@IBDesignable
class EditText: UITextField{
    
    @IBInspectable var leftImage: UIImage?{
        didSet {
            update();
        }
    }
    
    @IBInspectable var leftPadding:CGFloat = 0;
    
    @IBInspectable var iconColor: UIColor = UIColor.lightGray{
        didSet{
            update();
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.white{
        didSet{
            update();
        }
    }
    
    @IBInspectable var placeholderFont: UIFont = UIFont(name: "OpenSans-Regular", size: 17)!{
        didSet{
            update();
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var text = super.leftViewRect(forBounds: bounds);
        text.origin.x += leftPadding;
        return text;
    }
    
    func update() {
        if let image = leftImage{
            leftViewMode = .always;
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));
            imageView.contentMode = .scaleAspectFill;
            imageView.image = image;
            imageView.tintColor = iconColor;
            leftView = imageView;
        } else{
            leftViewMode = .never;
            leftView = nil;
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor,
              NSAttributedString.Key.font: placeholderFont
        ]);
    }
}
