//
//  SKModelTypeableView.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import UIKit

protocol SKModelTypeableView {
    
    func onRegisterCell(
        tableView: UITableView
    )
    
    func onCellView(
        model: Any?,
        indexPath: IndexPath,
        tableView: UITableView
    ) -> UITableViewCell
    
    func onHeightView(
        frame: CGRect
    ) -> CGFloat
    
}
