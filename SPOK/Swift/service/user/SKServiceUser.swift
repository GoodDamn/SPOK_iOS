//
//  SKServiceUser.swift
//  SPOK
//
//  Created by GoodDamn on 21/09/2024.
//

import Foundation
import FirebaseDatabase

final class SKServiceUser {
    
    weak var onGetUserData: SKListenerOnGetUserData? = nil
    
    final func setUserData(
        key: String,
        data: Any?,
        completion: (()->Void)? = nil
    ) {
        Database.user()?.child(
            key
        ).setValue(
            data
        ) { [weak self] error, _ in
            completion?()
        }
    }
    
    final func getUserDataAsync(
        key: String
    ) {
        Database.user()?.child(
            key
        ).observeSingleEvent(
            of: .value
        ) { [weak self] snapshot in
            self?.onGetUserData?.onGetUserData(
                key: key,
                data: snapshot.value
            )
            
        }
    }
    
    final func removeUserData(
        key: String,
        completion: (()->Void)? = nil
    ) {
        Database.user()?.child(
            key
        ).removeValue { error, _ in
            completion?()
        }
    }
    
}
