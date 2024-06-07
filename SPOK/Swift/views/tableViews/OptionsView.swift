//
//  OptionsTableView.swift
//  SPOK
//
//  Created by GoodDamn on 08/02/2024.
//

import Foundation
import UIKit.UIStackView

final class OptionsView
    : UIView {
    
    public var mOptionSize: CGSize = .zero
    
    final var mOptions: [Option] = [] {
        didSet {
            reloadData()
        }
    }
    
    init(
        frame: CGRect,
        rowHeight: CGFloat
    ) {
        mOptionSize = CGSize(
            width: frame.width,
            height: rowHeight
        )
        
        super.init(
            frame: frame
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

extension OptionsView {
    
    private func reloadData() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        var yOffset: CGFloat = 0
        
        for option in mOptions {
            
            let view = OptionView(
                frame: CGRect(
                    origin: CGPoint(
                        x: 0,
                        y: yOffset
                    ), size: mOptionSize
                )
            )
            
            view.onClick = option.select
            
            view.iconColor = option.iconColor
            view.image = option.image
            view.text = option.text
            view.textColorr = option.textColor
            
            addSubview(
                view
            )
            
            view.primaryView(
                view: option.withView
            )
            yOffset += mOptionSize.height
        }
        
    }
    
}

/*
extension OptionsTableView
    : UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        mOptions[indexPath.row]
            .select?()
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
        
        cell.textColorr = option.textColor
        cell.iconColor = option.iconColor
        
        cell.image = option.image
        cell.text = option.text
        
        cell.primaryView(
            view: option.withView
        )
        
        return cell
    }
    
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return mOptions.count
    }
    
}
*/
