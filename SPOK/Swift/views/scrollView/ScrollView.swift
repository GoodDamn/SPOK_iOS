//
//  ScrollView.swift
//  SPOK
//
//  Created by GoodDamn on 29/07/2024.
//

import UIKit

final class ScrollView
    : UIScrollView {
    
    var paddingBottom: CGFloat = 0
    
    private func initialize() {
        backgroundColor = .background()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        initialize()
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
        initialize()
    }
    
    func configure(
        parent: UIView,
        contentView: UIView
    ) {
        subviews.last?.removeFromSuperview()
        
        parent.addSubview(
            self
        )
        
        translatesAutoresizingMaskIntoConstraints
            = false
        
        addSubview(
            contentView
        )
        
        contentView.translatesAutoresizingMaskIntoConstraints
            = false
                
        NSLayoutConstraint.activate([
            topAnchor.constraint(
                equalTo: parent.topAnchor
            ),
            bottomAnchor.constraint(
                equalTo: parent.bottomAnchor
            ),
            leadingAnchor.constraint(
                equalTo: parent.leadingAnchor
            ),
            trailingAnchor.constraint(
                equalTo: parent.trailingAnchor
            ),
            
            contentView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            
            
            contentView.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            
            NSLayoutConstraint(
                item: contentView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: contentView.height() + paddingBottom
            )
        ])
        
    }
    
}
