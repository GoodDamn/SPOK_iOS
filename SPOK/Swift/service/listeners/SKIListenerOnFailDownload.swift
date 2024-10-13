//
//  SKIListenerOnFailDownload.swift
//  SPOK
//
//  Created by GoodDamn on 13/10/2024.
//

import Foundation

protocol SKIListenerOnFailDownload
: AnyObject {
    func onFailDownload(
        error: Error?
    )
}
