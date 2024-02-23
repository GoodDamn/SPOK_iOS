//
//  PremiumService.swift
//  SPOK
//
//  Created by GoodDamn on 04/02/2024.
//

import Foundation

final class PremiumService {
    
    private static let TAG = "PremiumService"
    
    var mOnCheckPremium: ((Bool) -> Void)? = nil
    
    private var mTime = 0
    
    public func start() {
        
        DatabaseUtils.time { [weak self] time in
            self?.mTime = time
            self?.startService()
        }
    }
    
    private func startService() {
        checkPayment(
            Keys.ID_PAYMENT_TEMP
        ) { [weak self] withSub, payIdTemp in
        
            if withSub {
                
                DatabaseUtils
                    .setUserValue(
                        payIdTemp!,
                        to: Keys.ID_PAYMENT
                    )
                
                DatabaseUtils
                    .deleteUserValue(
                        key: Keys.ID_PAYMENT_TEMP
                    )
                
                self?.mOnCheckPremium?(withSub)
                return
            }
            
            
            self?.checkPayment(
                Keys.ID_PAYMENT
            ) { withSub, payId in
                self?.mOnCheckPremium?(withSub)
            }
            
        }
    }
    
    private func checkPayment(
        _ paymentType: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        processPayment(
            paymentType
        ) { [weak self] info in
            
            // No sub
            guard let s = self,
                  info != nil else {
                completion(false,nil)
                return
            }
            
            let withSub = s.checkSub(
                info
            )
            
            completion(
                withSub,
                info!.id
            )
        }
        
    }
    
    private func checkSub(
        _ info: PaymentInfo?
    ) -> Bool {
        guard let info = info else {
            // No sub
            return false
        }
        
        if info.status != .success {
            return false
        }

        let d = mTime - info.createdTime
        
        Log.d(
            PremiumService.TAG,
            "DELTA_TIME:",
            d,
            mTime,
            info.createdTime
        )
        
        return d <= 2678400 // 31 days
    }
    
    private func processPayment(
        _ paymentType: String,
        completion: @escaping (PaymentInfo?) -> Void
    ) {
        DatabaseUtils.userValue(
            from: paymentType
        ) { value in
            
            guard let payid = value as? String else {
                completion(nil)
                return
            }
            
            PaymentProcess.getPaymentInfo(
                id: payid
            ) { info in
                completion(info)
            }
        }
        
        
    }
    
}
