//
//  SheepCounterViewController.swift
//  SPOK
//
//  Created by GoodDamn on 15/01/2024.
//

import Foundation
import UIKit

class SheepCounterViewController
    : StackViewController {
    
    private var mCounter = 1
    
    private var mExtrabold: UIFont? = nil
    
    private weak var mPrevc: UITextViewPhrase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let h = view.frame.height
        
        mExtrabold = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * 0.086
        )
        
        ViewUtils.createHeader(
            in: view,
            title: "Счётчик\nовечек...",
            subtitle: "Считай бесконечных овечек, чтобы\nлучше уснуть.",
            subtitleSize: 0.041
        )
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.084
            )
        
        let sizeSheep = w * 0.25
        
        let sheep = UIImageView(
            frame: CGRect(
                x: (w - sizeSheep) * 0.5,
                y: (h - sizeSheep) * 0.5,
                width: sizeSheep,
                height: sizeSheep
            )
        )
        
        sheep.image = UIImage(
            named: "sheep"
        )
        
        let ofx = w * 0.217
        let lTap = UILabel(
            frame: CGRect(
                x: ofx,
                y: h * 0.75,
                width: w-ofx*2,
                height: 0
            )
        )
        
        lTap.numberOfLines = 0
        lTap.font = UIFont(
            name: "OpenSans-SemiBold",
            size: w * 0.04
        )
        lTap.text = "Нажимай на экран и считай овечек."
        lTap.textColor = .white
        lTap.textAlignment = .center
        lTap.sizeToFit()
        
        lTap.frame.origin.x =
            (w-lTap.frame.width) * 0.5
        
        view.addSubview(btnClose)
        view.addSubview(sheep)
        view.addSubview(lTap)
        
        let g = UITapGestureRecognizer(
            target: self,
            action: #selector(onTap(_:))
        )
        
        g.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(
            g
        )
    }
    
    @objc func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        
        if mCounter == 1 {
            // 0,1,4
            
            let s = view.subviews
            
            UIView.animate(
                withDuration: 0.7,
                animations: {
                    s[0].alpha = 0.0
                    s[1].alpha = 0.0
                    s[4].alpha = 0.0
                }
            ) { b in
                s[0].removeFromSuperview()
                s[1].removeFromSuperview()
                s[4].removeFromSuperview()
            }
        }
        
        let f = view.frame
        
        let a = UITextViewPhrase(
            frame: CGRect(
                x: 0,
                y: f.height * 0.7,
                width: f.width,
                height: 0
            ), String(mCounter)
        )
        
        a.textColor = .white
        a.font = mExtrabold
        
        view.addSubview(a)
        
        a.show()
        
        mPrevc?.hide(300)
        
        mPrevc = a
        
        mCounter += 1
    }
    
}
