//
//  UITableViewTypeable.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import UIKit

class UITableViewTypeable
: UITableView {
        
    var models: [SKModelTypeable]? = nil
    
    private let mViewTypes: [SKModelTypeableView]
    
    init(
        frame: CGRect,
        viewTypes: [SKModelTypeableView]
    ) {
        mViewTypes = viewTypes
        super.init(
            frame: frame,
            style: .plain
        )
        
        viewTypes.forEach { it in
            it.onRegisterCell(
                tableView: self
            )
        }
        
        delegate = self
        dataSource = self
    }
    
    required init?(
        coder: NSCoder
    ) {
        mViewTypes = []
        super.init(
            coder: coder
        )
    }
    
}

extension UITableViewTypeable
: UITableViewDataSource {
        
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        models?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let index = indexPath.row
        guard let model = models?[index] else {
            return UITableViewCell()
        }
        
        return mViewTypes[
            model.viewType
        ].onCellView(
            model: model.model,
            indexPath: indexPath,
            tableView: tableView
        )
    }
    
}

extension UITableViewTypeable
: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let i = indexPath.row
        guard let model = models?[i] else {
            return 0
        }
        
        return mViewTypes[
            model.viewType
        ].onHeightView(
            frame: tableView.frame
        )
    }
    
}
