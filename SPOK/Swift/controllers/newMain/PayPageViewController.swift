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
        
        /*
        
        let w = view.frame.width
        let h = view.frame.height
        
        let btnExit = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.084
            )
        
        
        
        let btnBuy = ViewUtils
            .button(
                text: "Оплатить 125 RUB"
            )
        
        LayoutUtils.button(
            for: btnBuy,
            view.frame,
            y: 0.55,
            textSize: 0.3
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
        )*/
    }
    
    @objc func btnBuyClick(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        
        /*mPaymentProcess = PaymentProcess(
            payment: mPayment
        )
        
        mPaymentProcess.start { [weak self] snap in
            
            guard let s = self else {
                return
            }
            
            print(s.TAG, "PaymentStart:", snap)
            
            DispatchQueue.ui {
                self?.pushConfirmPage(
                    snap
                )
                
                sender.isEnabled = true
                self?.mPaymentProcess = nil
            }
        }*/
        
    }
    
    @objc func btnExitClick(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        mOnStats?("payPageExit")
        popBaseAnim()
    }
 
    
    
    /*
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
         message: "Обрабатываем запрос приложения",
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
                     duration: 0.5
                 ) {
                     self.view.alpha = 0
                 }
             }
             
         }
     */
    
}
