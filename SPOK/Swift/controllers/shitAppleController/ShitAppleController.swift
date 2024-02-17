//
//  ShitAppleController.swift
//  SPOK
//
//  Created by GoodDamn on 16/02/2024.
//

import Foundation
import StoreKit
import UIKit

@available(iOS 15.4, *)
final class ShitAppleController
    : UIViewController {
    
    private let TAG = "ShitAppleController:"
    
    override func viewDidAppear(
        _ animated: Bool
    ) {
        super.viewDidAppear(animated)
        
        Task {
            await startShit()
        }
        
    }
    
    
    private final func startShit() async {
       
        var res: ExternalPurchase.NoticeResult?
        do {
            res = try await ExternalPurchase
                .presentNoticeSheet()
        } catch {
            
            print(
                TAG,
                "ERROR_PRESENT_NOTICE_SHIT",
                error
            )
            
            navigationController?
                .popViewController(
                    animated: true
                )
            
            return
        }
        
        let op = await ExternalPurchaseLink
            .canOpen
        
        print(TAG, "CAN_OPEN_NOTICE_SHIT", op)
        
        if res == .cancelled || !op {
            navigationController?
                .popViewController(
                    animated: true
                )
            return
        }
        
        try? await ExternalPurchaseLink.open()
    }

}
