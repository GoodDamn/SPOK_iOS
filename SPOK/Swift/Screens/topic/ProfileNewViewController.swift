//
//  ProfileNewViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit
import FirebaseDatabase

class ProfileNewViewController
    : StackViewController {
    
    private let mDatabase = Database
        .database()
        .reference(
            withPath: "Stats/iOS"
        )
    
    private var mCurrentStreak = 0
    
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
        
        let marginTop = h * 0.04
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
                y: h * 0.12,
                width: w,
                height: 0.05 * w
            )
        )
        
        let marginLeftSub = w * 0.1
        
        let lSubtitleHead = UILabel(
            frame: CGRect(
                x: marginLeftSub,
                y: h * 0.165,
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
        
        
        let himage2 = w * 0.434
        
        let imageView2 = UIImageView(
            frame: CGRect(
                x: w * 0.297,
                y: lSubtitleHead
                    .frame
                    .origin
                    .y + lSubtitleHead
                    .frame.height + h*0.03,
                width: himage2,
                height: himage2
            )
        )
        
        imageView2.image = UIImage(
            named: "i"
        )
        
        let himage1 = w * 0.352
        let offset = w * 0.14
        let ximg13 = lSubtitleHead
            .frame
            .origin
            .y + lSubtitleHead
            .frame.height + h*0.06
        
        let imageView1 = UIImageView(
            frame: CGRect(
                x: w-(himage1-offset),
                y: ximg13,
                width: himage1,
                height: himage1
            )
        )
        
        imageView1.image = UIImage(
            named: "o"
        )
        
        let imageView3 = UIImageView(
            frame: CGRect(
                x: -offset,
                y: ximg13,
                width: himage1,
                height: himage1
            )
        )
        
        imageView3.image = UIImage(
            named: "j"
        )
        
        let ivf = imageView2.frame
        let lPrice = UILabel(
            frame: CGRect(
                x: 0,
                y: ivf.origin.y + ivf.height + h * 0.04,
                width: w,
                height: h * 0.028
            )
        )
        
        let a = NSMutableAttributedString(
            string: "249 RUB 125 RUB"
        )
        
        let strikeColor = UIColor
            .white
            .withAlphaComponent(
                0.7
            )
        
        a.addAttributes([
            NSAttributedString.Key
                .font: bold?
                    .withSize(lPrice
                        .frame.height * 0.6
            ),
            NSAttributedString.Key
                .foregroundColor: strikeColor,
            NSAttributedString.Key
                .strikethroughStyle: NSUnderlineStyle
                .single
                .rawValue,
            NSAttributedString.Key
                .strikethroughColor:
                    strikeColor
        ],range: NSRange(
            location: 0,
            length: 7)
        )
        
        lPrice.textColor = .white
        lPrice.textAlignment = .center
        lPrice.font = bold?
            .withSize(lPrice.frame.height)
        lPrice.attributedText = a
        
        let btnOpen = ViewUtils
            .button(
                text: "Открыть полный доступ",
                y: 0.61,
                textSize: 0.35,
                view
            )
        
        let hshare = h * 0.25
        let shareLeft = w * 0.1
        let wshare = w-shareLeft*2
        let shareView = UIView(
            frame: CGRect(
                x: shareLeft,
                y: h * 0.68,
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
                y: 0.85,
                textSize: 0.35,
                view
            )
        
        view.addSubview(lTitle)
        view.addSubview(lTitleHead)
        view.addSubview(lSubtitleHead)
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        
        view.addSubview(lPrice)
        
        view.addSubview(btnOpen)
        view.addSubview(shareView)
        
        shareView.addSubview(lShare)
        view.addSubview(btnShare)
        
        
        btnOpen.addTarget(
            self,
            action: #selector(
                btnOpenFullAccess(_:)
            ),
            for: .touchUpInside
        )
        
        btnShare.addTarget(
            self,
            action: #selector(
                btnShareImpression(_:)
            ),
            for: .touchUpInside
        )
        
    }
    
    @objc func btnOpenFullAccess(
        _ sender: UIButton
    ) {
        let c = PayPageViewController()
        c.view.alpha = 0
        
        c.mOnStats = { child in
            self.addStat(child)
        }
        
        c.mOnBack = {
            self.mCurrentStreak += 1
        }
        
        addStat("payPage")
        
        push(
            c,
            animDuration: 0.5
        ) {
            c.view.alpha = 1.0
        }
    }
    
    @objc func btnShareImpression(
        _ sender: UIButton
    ) {
        
    }
    
    private func addStat(
        _ child: String
    ) {
        mDatabase
            .child("\(mCurrentStreak)_\(child)")
            .setValue(ServerValue
                .increment(1)
            )
    }
}
