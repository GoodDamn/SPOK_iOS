//
//  Option.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UIImage

struct Option {
    let image: UIImage?
    let text: String?
    let textColor: UIColor?
    let iconColor: UIColor?
    let select: (()->Void)?
}
