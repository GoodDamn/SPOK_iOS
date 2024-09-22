//
//  SKServicePremium.swift
//  SPOK
//
//  Created by GoodDamn on 04/02/2024.
//

import Foundation

final class SKServicePremium {
    
    weak var onGetPremiumStatus: SKListenerOnGetPremiumStatus? = nil
    
    private let mServiceYookassa = SKServiceYooKassa()
    private let mServiceUser = SKServiceUser()
    
    var serverTimeSec = 0
    
    init() {
        mServiceYookassa.onGetPaymentInfo = self
        mServiceUser.onGetUserData = self
    }
    
    func getPremiumStatusAsync() {
        mServiceUser.getUserDataAsync(
            key: Keys.ID_PAYMENT
        )
    }
}

extension SKServicePremium
: SKListenerOnGetUserData {
    
    func onGetUserData(
        key: String,
        data: Any?
    ) {
        guard let payId = data as? String else {
            onGetPremiumStatus?.onGetPremiumStatus(
                hasPremium: false
            )
            return
        }
        
        mServiceYookassa.getPaymentInfoAsync(
            payId: payId
        )
    }
    
}

extension SKServicePremium
: SKListenerOnGetPaymentInfo {
    
    func onGetPaymentInfo(
        info: SKModelPaymentInfo?
    ) {
        guard let info = info else {
            onGetPremiumStatus?.onGetPremiumStatus(
                hasPremium: false
            )
            return
        }
        
        let withPremium = info.status != .success &&
            serverTimeSec - info.createdTime < .premiumLifeTimeSec()
        
        onGetPremiumStatus?.onGetPremiumStatus(
            hasPremium: withPremium
        )
        
    }
    
}
