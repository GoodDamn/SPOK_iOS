//
//  PayPageViewController.swift
//  SPOK
//
//  Created by GoodDamn on 12/01/2024.
//

import Foundation
import UIKit

class PayPageViewController
    : StackViewController {
    
    private let TAG = "PayPageViewController:"
    
    public var mOnStats: ((String)->Void)? = nil
    public var mOnBack: (()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurView = UIVisualEffectView(
            frame: view.frame
        )
        
        blurView.alpha = 0.4
        
        blurView.effect = UIBlurEffect(
            style: .extraLight
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeBtnExit = 0.084 * w
        
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
        
        let marginTitle = w * 0.18
        let lTitle = UILabel(
            frame: CGRect(
                x: marginTitle,
                y: h * 0.4,
                width: 0,
                height: 0
            )
        )
        
        lTitle.textAlignment = .center
        lTitle.numberOfLines = 0
        lTitle.font = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * 0.053
        )
        lTitle.textColor = .white
        lTitle.text = "Перейти на\nстраницу оплаты?"
        lTitle.sizeToFit()
        
        let f = lTitle.frame
        
        lTitle.frame.origin.x = (w-f.size.width) * 0.5
        
        let btnBuy = ViewUtils
            .button(
                text: "Оплатить 125 RUB",
                y: 0.55,
                textSize: 0.3,
                view
            )
        
        btnBuy.frame.origin.y = lTitle.frame.origin.y + lTitle.frame.height + h * 0.03
        
        view.addSubview(blurView)
        view.addSubview(btnExit)
        
        view.addSubview(lTitle)
        view.addSubview(btnBuy)
        
        
        btnExit.addTarget(
            self,
            action: #selector(
                btnExitClick(_:)
            ),
            for: .touchUpInside
        )
        
        btnBuy.addTarget(
            self,
            action: #selector(
                btnBuyClick(_:)
            ), for: .touchUpInside
        )
    }
    
    @objc func btnBuyClick(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        
        let alert = UIAlertController(
            title: "Ошибка.",
            message: "Проблемы с произведением оплаты. Попробуйте позже.",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Вернуться",
            style: .default
        ) { action in
            // Analytics
            self.mOnStats?("payPageBack")
            self.mOnBack?()
        }
        
        alert.addAction(action)
        
        let alertProcess = UIAlertController(
            title: "Минутку...",
            message: "Обрабатываю запрос приложения",
            preferredStyle: .alert)
        
        self.present(
            alertProcess,
            animated: true
        )
        
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + 2.5
            ) {                alertProcess.dismiss(
                    animated: true
                ) {
                    self.navigationController?.present(
                        alert,
                        animated: true
                    )
                    
                    self.pop(
                        at: 1,
                        duration: 0.5
                    ) {
                        self.view.alpha = 0
                    }
                }
                
            }
    }
    
    @objc func btnExitClick(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        mOnStats?("payPageExit")
        pop(
            at: 1,
            duration: 0.5
        ) {
            self.view.alpha = 0
        }
    }
 
}
