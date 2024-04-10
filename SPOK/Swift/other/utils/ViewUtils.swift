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
        text: String
    ) -> UIButton {
        
        let btnStart = UIButton()
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 18
        )
        
        btnStart.backgroundColor = UIColor
            .accent()
        
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
    
    public static func debugLines(
        in view: UIView
    ) {
        let c = view.center
        let path = UIBezierPath()
        path.move(
            to: CGPoint(
                x: c.x,
                y: 0
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: c.x,
                y: c.y + c.y
            )
        )
        
        path.move(
            to: CGPoint(
                x: 0,
                y: c.y
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: c.x + c.x,
                y: c.y
            )
        )
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        layer.strokeColor = UIColor.white
            .cgColor
        layer.fillColor = nil
        
        layer.lineWidth = 2.0
        
        view.layer.addSublayer(
            layer
        )
    }
    
    public static func createHeader(
        frame: CGRect,
        title: String,
        subtitle: String,
        titleSize: CGFloat = 0.086,
        subtitleSize: CGFloat = 0.054
    ) -> UIView {
        
        let w = frame.width
        let h = frame.height
        
        let space = h * 0.01
        let marginLeft = w * 0.094
        
        let ts = w * titleSize
        let tts = w * subtitleSize
        
        let header = UIHeaderView(
            frame: CGRect(
                x: marginLeft,
                y: 0,
                width: w - marginLeft,
                height: 0
            )
        )
        
        header.titleSize = ts
        header.subtitleSize = tts
        header.spacing = space
        header.title = title
        header.subtitle = subtitle
        
        header.layout()
        return header
    }
    
    public static func buttonClose(
        _ systemNameImage: String = "xmark",
        in view: UIView,
        sizeSquare si: CGFloat,
        iconProp: CGFloat = 0.5
    ) -> UIButton {
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeBtnExit = si * w
        
        let iconSize = sizeBtnExit * iconProp
        
        let btnExitConfig = UIImage
            .SymbolConfiguration(
                pointSize: iconSize,
                weight: .bold,
                scale: .default
            )
        
        let btnExit = UIButton(
            frame: CGRect(
                x: w - sizeBtnExit - w * 0.06,
                y: h * 0.04 - iconSize * 0.5,
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
        
        btnExit.setImage(
            UIImage(
                systemName: systemNameImage,
                withConfiguration: btnExitConfig
            ),
            for: .normal
        )
        
        return btnExit
    }
    
    public static func progressBar(
        frame: CGRect,
        x: CGFloat = 0.35,
        y: CGFloat = 0.8,
        width: CGFloat = 0.3,
        height: CGFloat = 0.03
    ) -> ProgressBar {
        
        let w = frame.width
        let h = frame.height
        
        let pb = ProgressBar(
            frame: CGRect(
                x: w * x,
                y: h * y,
                width: w * width,
                height: h * height
            )
        )
        
        pb.mColorBack = .white
            .withAlphaComponent(0.2)
        
        pb.mColorProgress = .white
        pb.maxProgress = 100
        pb.mProgress = 0
        
        return pb
    }
    
    public static func alertAction(
        title: String,
        message: String? = nil,
        controller: UIViewController,
        accept: @escaping ((UIAlertAction) -> Void)
    ) {
        
        let c = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        c.addAction(
            UIAlertAction(
                title: "Да",
                style: .destructive,
                handler: accept
            )
        )
                    
        c.addAction(
            UIAlertAction(
                title: "Нет",
                style: .cancel
            )
        )
        
        controller.present(
            c,
            animated: true
        )
    }
    
}
