//
//  SKDelegateOnGetTopicContent.swift
//  SPOK
//
//  Created by GoodDamn on 30/08/2024.
//

import Foundation

protocol SKDelegateOnGetTopicContent
: AnyObject {
    func onGetTopicContent(
        model: SKModelTopicContent
    )
}
