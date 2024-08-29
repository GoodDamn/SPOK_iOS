//
//  CollectionRowView.swift
//  SPOK
//
//  Created by GoodDamn on 17/01/2024.
//

import Foundation

public class CollectionRowView
    : Collection {
    
    let setupView: ((UITableViewCellCollection)->Void)
    
    init(
        title: String,
        titleSize: CGFloat,
        height: CGFloat,
        idCell: String,
        setupView: @escaping ((UITableViewCellCollection)->Void)
    ) {
        self.setupView = setupView
        super.init(
            title: title,
            height: height,
            idCell: idCell,
            titleSize: titleSize
        )
    }
    
}
