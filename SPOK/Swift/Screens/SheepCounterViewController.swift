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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = view.frame.width
        let h = view.frame.height
        
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
    }
    
}
