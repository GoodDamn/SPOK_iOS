//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class ProfileNewViewController
    : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        let w = view.frame.width
        let h = view.frame.height
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: 15
        )
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 15
        )
        
        let semiBold = UIFont(
            name: "OpenSans-SemiBold",
            size: 15
        )
        
        let marginTop = h * 0.08
        let marginLeft = w * 0.05
        
        let lTitle = UILabel(
            frame: CGRect(
                x: marginLeft,
                y: marginTop,
                width: w-marginLeft,
                height: w * 0.06
            )
        )
        
        let lTitleHead = UILabel(
            frame: CGRect(
                x: 0,
                y: h * 0.18,
                width: w,
                height: 0.05 * w
            )
        )
        
        let marginLeftSub = w * 0.1
        
        let lSubtitleHead = UILabel(
            frame: CGRect(
                x: marginLeftSub,
                y: h * 0.22,
                width: w-marginLeftSub,
                height: 0.032 * w
            )
        )
        
        lTitle.text = "Профиль"
        lTitle.textColor = .white
        lTitle.font = extraBold?
            .withSize(lTitle.frame.height)
        
        lTitleHead.textAlignment = .center
        lTitleHead.text = "Теперь можно все"
        lTitleHead.textColor = .white
        lTitleHead.font = bold?
            .withSize(lTitleHead.frame.height)
        
        lSubtitleHead.textAlignment = .center
        lSubtitleHead.numberOfLines = 0
        lSubtitleHead.text = "Открой полный доступ ко всему контенту в приложении. Засыпай быстрее и улучши качество своего сна вместе со SPOK"
        lSubtitleHead.textColor = .white
        lSubtitleHead.font = semiBold?
            .withSize(lSubtitleHead.frame.height)
        
        lSubtitleHead.sizeToFit()
        
        
        let btnOpen = ViewUtils
            .button(
                text: "Открыть полный доступ",
                y: 0.55,
                view
            )
        
        let hshare = h * 0.25
        let shareLeft = w * 0.1
        let wshare = w-shareLeft*2
        let shareView = UIView(
            frame: CGRect(
                x: shareLeft,
                y: h * 0.65,
                width: wshare,
                height: hshare
            )
        )
        
        shareView.backgroundColor = UIColor(
            red: 17.0/255,
            green: 43.0/255,
            blue: 94.0/255,
            alpha: 1.0
        )
        shareView
            .layer
            .cornerRadius = hshare * 0.1
        
        let lShareLeft = wshare * 0.1
        let lShare = UILabel(
            frame: CGRect(
                x: lShareLeft,
                y: hshare * 0.15,
                width: wshare - lShareLeft*2,
                height: 0
            )
        )
        
        lShare.text = "Поделись своим впечатлением.\nСкажи, что тебе нравится и не нравится в приложении, а мы обещаем, что сделаем его лучше!"
        lShare.textColor = .white
        lShare.font = semiBold?
            .withSize(hshare * 0.067)
        lShare.numberOfLines = 0
        lShare.textAlignment = .center
        lShare.sizeToFit()
        
        let btnShare = ViewUtils
            .button(
                text: "Поделиться впечатлением",
                y: 0.82,
                view
            )
        
        view.addSubview(lTitle)
        view.addSubview(lTitleHead)
        view.addSubview(lSubtitleHead)
        view.addSubview(btnOpen)
        view.addSubview(shareView)
        
        shareView.addSubview(lShare)
        view.addSubview(btnShare)
    }
}
