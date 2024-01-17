//
//  Collection.swift
//  SPOK
//
//  Created by GoodDamn on 13/01/2024.
//

import Foundation
public class Collection {
    let title: String
    let height: CGFloat
    let titleSize: CGFloat
    let idCell: String
    
    init(
        title: String,
        height: CGFloat,
        idCell: String,
        titleSize: CGFloat
    ) {
        self.title = title
        self.height = height
        self.idCell = idCell
        self.titleSize = titleSize
    }
}
