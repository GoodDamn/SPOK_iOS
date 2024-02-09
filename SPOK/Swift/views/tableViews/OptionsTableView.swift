//
//  OptionsTableView.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UITableView

final class OptionsTableView
    : UITableView {
    
    private var mOptions: [Option]!
    
    init(
        frame: CGRect,
        source: inout [Option],
        style: UITableView.Style
    ) {
        mOptions = source
        super.init(
            frame: frame,
            style: style
        )
        
        delegate = self
        dataSource = self
     
        register(
            OptionTableCell.self,
            forCellReuseIdentifier: "option"
        )
        
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
}

extension OptionsTableView
    : UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
    }
        
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 207
    }
    
}


extension OptionsTableView
    : UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "option",
            for: indexPath
        )
        
        
        return cell
    }
    
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 2
    }
    
}

