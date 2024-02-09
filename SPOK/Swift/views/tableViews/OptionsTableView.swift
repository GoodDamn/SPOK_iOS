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
    
    public static var mOptionSize: CGSize = .zero
    
    private final let mOptions: [Option]!
    
    init(
        frame: CGRect,
        source: [Option],
        rowHeight: CGFloat,
        style: UITableView.Style
    ) {
        OptionsTableView.mOptionSize = CGSize(
            width: frame.width,
            height: rowHeight
        )
        mOptions = source
        super.init(
            frame: frame,
            style: style
        )
        
        delegate = self
        dataSource = self
     
        register(
            OptionTableCell.self,
            forCellReuseIdentifier: OptionTableCell.id
        )
        
    }
    
    required init?(
        coder: NSCoder
    ) {
        mOptions = []
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
        return OptionsTableView
            .mOptionSize
            .height
    }
    
}


extension OptionsTableView
    : UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OptionTableCell.id,
            for: indexPath
        ) as? OptionTableCell else {
            return UITableViewCell()
        }
        
        let option = mOptions[
            indexPath.row
        ]
        
        cell.image = option.image
        cell.text = option.text
        
        return cell
    }
    
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return mOptions.count
    }
    
}

