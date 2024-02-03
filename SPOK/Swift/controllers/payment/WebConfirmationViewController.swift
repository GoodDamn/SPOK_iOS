//
//  WebConfirmationViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation
import UIKit
import WebKit

class WebConfirmationViewController
    : StackViewController {
    
    var mPaymentSnap: PaymentSnapshot!
    private var mWeb: WKWebView!

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
    }
    
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
            
            if let payID = payID {
                let url = Keys.URL_PAYMENTS
                .appendingPathComponent(
                    payID
                ).appendingPathComponent(
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
    
}


extension WebConfirmationViewController
    : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
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
        
        print(
            "WebView: LINK_URL:",
            redirUrl
        )
        
        if redirUrl == Keys.DEEP_LINK_SUB {
            
            PaymentProcess.getPaymentInfo(
                id: mPaymentSnap.id
            ) { [weak self] info in
                
                if self == nil {
                    return
                }
                
                DispatchQueue.ui {
                    self!.processPayment(
                        info
                    )
                }
                
            }
            
        }
        
        decisionHandler(.cancel)
        
    }
    
    private func processPayment(
        _ info: PaymentInfo
    ) {
        if info.status == .success {
            // Register sub
            
            popBaseAnim()
            
            return
        }
        
        alert(
            "Выполнение платежа будет прервано"
        )
    }
    
}

extension WebConfirmationViewController
    : WKUIDelegate {}
