//
//  PaymentConfirmationListener.swift
//  SPOK
//
//  Created by GoodDamn on 04/02/2024.
//

import Foundation

protocol PaymentConfirmationListener
    : AnyObject {
    
    func onPaid()
    
    func onExitPayment()
    
}
