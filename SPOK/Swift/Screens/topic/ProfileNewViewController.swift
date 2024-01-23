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
        let h = view.frame.height - mTopOffset
        
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
                y: mTopOffset == 0 ? marginTop : mTopOffset,
                width: w-marginLeft,
                height: w * 0.06
            )
        )
        
        let lTitleHead = UILabel(
            frame: CGRect(
                x: 0,
                y: lTitle
                    .frame.bottom() + h * 0.05,
                width: w,
                height: 0.05 * w
            )
        )
        
        let marginLeftSub = w * 0.108
        
        let lSubtitleHead = UILabel(
            frame: CGRect(
                x: marginLeftSub,
                y: lTitleHead.frame.bottom() + h*0.02,
                width: w-marginLeftSub*2,
                height: 0.032 * w
            )
        )
        
        lTitle.text = "Профиль"
        lTitle.textColor = .white
        lTitle.font = extraBold?
            .withSize(lTitle.frame.height)
        
        lTitle.sizeToFit()
        
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
        lSubtitleHead.frame.center(
            targetWidth: w
        )
        
        let himage2 = w * 0.434
        
        let imageView2 = UIImageView(
            frame: CGRect(
                x: w * 0.297,
                y: lSubtitleHead
                    .frame
                    .bottom() + h*0.03,
                width: himage2,
                height: himage2
            )
        )
        
        imageView2.image = UIImage(
            named: "i"
        )
        
        let himage1 = w * 0.352
        let offset = w * 0.14
        let ximg13 = lSubtitleHead.frame.bottom() + h*0.06
        
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
        
        let lPrice = UILabel(
            frame: CGRect(
                x: 0,
                y: imageView2.frame.bottom() + h * 0.02,
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
        
        lPrice.frame.offsetX(
            w * -0.065
        )
        
        let btnOpen = ViewUtils
            .button(
                text: "Открыть полный доступ"
            )
        
        LayoutUtils.button(
            for: btnOpen,
            view.frame,
            y: 0.85,
            width: 0.702,
            textSize: 0.3
        )
        
        btnOpen.frame.origin.y = lPrice.frame.bottom() + h * 0.03
        
        let hshare = h * 0.25
        let shareLeft = w * 0.051
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
            .cornerRadius = hshare * 0.083
        
        
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
                text: "Поделиться впечатлением"
            )
        
        LayoutUtils.button(
            for: btnShare,
            view.frame,
            y: 0.6,
            width: 0.702,
            textSize: 0.3
        )
        
        btnShare.frame.origin.y = shareView.frame.bottom() - btnShare.frame.height - shareView.frame.height * 0.155
        
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
        let app = UIApplication.shared
        
        guard let url = URL(string: "https://forms.yandex.ru/cloud/659e823af47e735258a77960"
        ) else {
            print("ProfileNewViewController", "URL_ERROR:")
            return
        }
        
        app.open(url) { success in
            
            if success {
                print("SUCCESS")
            }
            
        }
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

extension CGRect {
    
    func bottom() -> CGFloat {
        return height + origin.y
    }

    mutating func center(
        targetWidth: CGFloat
    ) {
        origin.x = (targetWidth - width) * 0.5
    }
    
    mutating func offsetX(
        _ offx: CGFloat
    ) {
        origin.x = origin.x + offx
    }
    
}
