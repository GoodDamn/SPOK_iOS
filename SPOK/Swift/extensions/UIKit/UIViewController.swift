//
//  UIViewController.swift
//  SPOK
//
//  Created by GoodDamn on 08/08/2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupKeyboardEditEnd() {
        forEachView { [weak self] v in
            
            if v is UITextField
                || v is UIViewListenable {
                return
            }
            
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(
                    self?.onTapEndEditing(_:)
                )
            )
            tap.numberOfTapsRequired = 1
            
            v.addGestureRecognizer(
                tap
            )
        }
    }
    
    func forEachView(
        handle: (UIView) -> Void
    ) {
        iterateSubviews(
            v: view,
            handle: handle
        )
    }
    
    private func iterateSubviews(
        v: UIView,
        handle: (UIView) -> Void
    ) {
        if v.subviews.isEmpty {
            handle(v)
        }
        v.subviews.forEach { [weak self] vi in
            self?.iterateSubviews(
                v: vi,
                handle: handle
            )
        }
    }
    
    @objc private func onTapEndEditing(
        _ sender: UITapGestureRecognizer
    ) {
        sender.view?.endEditing(
            true
        )
    }
    
}
