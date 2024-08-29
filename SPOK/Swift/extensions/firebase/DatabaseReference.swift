//
//  DatabaseReference.swift
//  SPOK
//
//  Created by GoodDamn on 31/07/2024.
//

import FirebaseDatabase

extension DatabaseReference {
    
    func increment(
        _ inc: Int = 1
    ) {
        
        #if DEBUG
        #else
            observeSingleEvent(
                of: .value
            ) { [weak self] snap in
                let v = snap.value as? Int
                    ?? 0
                
                self?.setValue(
                    v + inc
                )
                
            }
        #endif
    }
    
}
