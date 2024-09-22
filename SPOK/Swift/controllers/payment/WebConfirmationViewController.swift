//
//  WebConfirmationViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation
import UIKit
import WebKit

final class WebConfirmationViewController
: StackViewController {
    
    private let TAG = "WebConfirmationViewController"

    weak var mPaymentListener:
        PaymentConfirmationListener? = nil
    
    var mPaymentSnap: PaymentSnapshot!
    private var mWeb: WKWebView!

    private let mServiceYookassa = SKServiceYooKassa()
    private let mServiceUser = SKServiceUser()
    
    override func loadView() {
        let config = WKWebViewConfiguration()
        mWeb = WKWebView(
            frame: UIScreen.main.bounds,
            configuration: config
        )
        
        mWeb.uiDelegate = self
        mWeb.navigationDelegate = self
        view = mWeb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mServiceYookassa.onGetPaymentInfo = self
        
        guard let url = URL(
            string: mPaymentSnap
                .confirmUrl
        ) else {
            popBaseAnim()
            return
        }
        
        let req = URLRequest(
            url: url
        )
        
        mWeb.load(req)
        
        mServiceUser.setUserData(
            key: Keys.ID_PAYMENT,
            data: mPaymentSnap.id
        )
    }
    
}


extension WebConfirmationViewController {
    
    private func alert(
        _ msg: String
    ) {
        
        let c = UIAlertController(
            title: "Прервать операцию?",
            message: msg,
            preferredStyle: .alert
        )
        
        let payID = mPaymentSnap?.id
        
        let action = UIAlertAction(
            title: "Да",
            style: .destructive
        ) { [weak self] action in
            
            self?.mServiceUser.removeUserData(
                key: Keys.ID_PAYMENT
            )
            
            self?.getStatRefId(
                "PAY_CANCEL"
            ).increment()
            
            if let payID = payID {
                let url = Keys.URL_PAYMENTS
                .append(
                    payID
                ).append(
                    "cancel"
                )
                
                HttpUtils.requestJson(
                    to: url,
                    header: HttpUtils
                        .header(),
                    body: ["":""],
                    method: "POST"
                ) { _ in}
            }
            
            self?.mPaymentListener?.onExitPayment()
            self?.popBaseAnim()
        }
        
        let actionCancel = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )
        
        c.addAction(action)
        c.addAction(actionCancel)
        
        present(
            c,
            animated: true
        )
        
    }
    
    private func processPayment(
        _ info: SKModelPaymentInfo
    ) {
        if info.status == .success {
            mPaymentListener?.onPaid()
            
            // register sub
            mServiceUser.setUserData(
                key: Keys.ID_PAYMENT,
                data: info.id
            )
            
            getStatRefId(
                "PAID"
            ).increment()
            
            popBaseAnim()
            return
        }
        
        alert(
            "Выполнение платежа будет прервано"
        )
    }
    
}

extension WebConfirmationViewController
    : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType !=
            .linkActivated {
            decisionHandler(.allow)
            return
        }
        
        guard let redirUrl = navigationAction
            .request
            .url?
            .absoluteString else {
            
            decisionHandler(.allow)
            
            return
        }
        
        Log.d(
            "WebView: LINK_URL:",
            redirUrl
        )
        
        if redirUrl == Keys.DEEP_LINK_SUB {
            mServiceYookassa.getPaymentInfoAsync(
                payId: mPaymentSnap.id
            )
        }
        
        decisionHandler(.cancel)
    }
    
}

extension WebConfirmationViewController
: SKListenerOnGetPaymentInfo {
    
    func onGetPaymentInfo(
        info: SKModelPaymentInfo?
    ) {
        if info == nil {
            return
        }
        
        DispatchQueue.ui { [weak self] in
            self?.processPayment(
                info!
            )
        }
    }
    
}

extension WebConfirmationViewController
: WKUIDelegate {}
