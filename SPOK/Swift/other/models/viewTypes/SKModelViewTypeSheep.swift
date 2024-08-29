//
//  SKModelViewTypeSheep.swift
//  SPOK
//
//  Created by GoodDamn on 29/08/2024.
//

import Foundation
import UIKit

final class SKModelViewTypeSheep
: SKModelTypeableView {

    private let mSize: CGSize
    
    init(
        size: CGSize
    ) {
        mSize = size
    }
    
    func onRegisterCell(
        tableView: UITableView
    ) {
        tableView.register(
            SheepViewCell.self,
            forCellReuseIdentifier: "1"
        )
    }
    
    func onHeightView(
        frame: CGRect
    ) -> CGFloat {
        mSize.height
    }
    
    func onCellView(
        model: Any?,
        indexPath: IndexPath,
        tableView: UITableView
    ) -> UITableViewCell {
        guard let sheepCell = tableView.dequeueReusableCell(
            withIdentifier: "1",
            for: indexPath
        ) as? SheepViewCell else {
            return UITableViewCell()
        }
        
        sheepCell.layout(
            with: mSize
        )
        
        return sheepCell
    }
}
