//
//  SKDelegateOnGetTopicPreview.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation

protocol SKDelegateOnGetTopicPreview
: AnyObject {
    func onGetTopicPreview(
        preview: SKModelTopicPreview
    )
}
