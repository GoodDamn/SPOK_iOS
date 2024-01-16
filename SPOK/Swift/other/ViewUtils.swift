//
//  ViewUtils.swift
//  SPOK
//
//  Created by GoodDamn on 11/01/2024.
//

import Foundation
import UIKit

public class ViewUtils {
    
    public static func button(
        text: String,
        y: CGFloat,
        textSize: CGFloat = 0.26,
        _ view: UIView
    ) -> UIButton {
        
        let w = view.frame.width
        let h = view.frame.height
        
        let wbtn = w * 0.702
        
        let btnStart = UIButton(
            frame: CGRect(
                x: (w - wbtn) * 0.5,
                y: h * y,
                width: wbtn,
                height: h * 0.05
            )
        )
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: textSize * btnStart.frame.height
        )
        
        btnStart.backgroundColor = UIColor(
            named: "btnBack"
        )
        
        btnStart
            .layer
            .cornerRadius = 0.17 * btnStart.frame.height
        
        btnStart.titleLabel?.font = bold
        btnStart.setTitleColor(
            .white,
            for: .normal
        )
        
        btnStart.setTitle(
            text,
            for: .normal)
        
        
        return btnStart
    }
    
    
    public static func createHeader(
        in view: UIView,
        title: String,
        subtitle: String,
        titleSize: CGFloat = 0.086,
        subtitleSize: CGFloat = 0.054
    ) {

        let f = view.frame
        
        let w = f.width
        let h = f.height
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * titleSize
        )
        
        let semiBold = UIFont(
            name: "OpenSans-SemiBold",
            size: w * subtitleSize
        )
        
        let marginLeft = w * 0.094
        
        let ww = w - marginLeft
        
        let lTitle = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: h*0.05,
                width: ww,
                height: 0
            )
        )
    
        lTitle.text = title
        lTitle.textColor = .white
        lTitle.font = extraBold
        lTitle.numberOfLines = 0
        lTitle.sizeToFit()
        
        let fr = lTitle.frame
        let or = fr.origin
        
        let lSubtitle = UILabel(
            frame: CGRect(
                x: or.x,
                y: fr.height + or.y + w * 0.05,
                width: ww,
                height: 0
            )
        )
        
        lSubtitle.text = subtitle
        lSubtitle.textColor = .white
        lSubtitle.font = semiBold
        lSubtitle.numberOfLines = 0
        
        lSubtitle.sizeToFit()
        
        view.addSubview(lTitle)
        view.addSubview(lSubtitle)
    }
    
    public static func buttonClose(
        in view: UIView,
        sizeSquare si: CGFloat
    ) -> UIButton {
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeBtnExit = si * w
        
        let btnExitConfig = UIImage
            .SymbolConfiguration(
                pointSize: sizeBtnExit * 0.5,
                weight: .medium,
                scale: .medium
            )
        
        let btnExit = UIButton(
            frame: CGRect(
                x: w-sizeBtnExit-w*0.06,
                y: h * 0.04,
                width: sizeBtnExit,
                height: sizeBtnExit
            )
        )
        
        btnExit.backgroundColor = .clear
        btnExit.tintColor = UIColor(
            red: 197.0 / 255,
            green: 197 / 255,
            blue: 197 / 255,
            alpha: 1.0
        )
        
        btnExit.setBackgroundImage(
            UIImage(
                systemName: "xmark",
                withConfiguration: btnExitConfig
            ),
            for: .normal)
        
        return btnExit
    }
    
}
