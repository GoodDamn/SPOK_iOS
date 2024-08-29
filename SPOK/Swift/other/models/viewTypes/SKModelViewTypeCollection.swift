//
//  SKModelViewTypeCollection.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import UIKit

final class SKModelViewTypeCollection
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
            UITableViewCellCollection.self,
            forCellReuseIdentifier: "0"
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
        
        guard let model = model as? SKModelCollection else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "0",
            for: indexPath
        ) as? UITableViewCellCollection else {
            return UITableViewCell()
        }
        
        cell.mTitle?.text = model.title
        
        cell.calculateBoundsTitle(
            with: mSize
        )
        
        return cell
    }
    
}
