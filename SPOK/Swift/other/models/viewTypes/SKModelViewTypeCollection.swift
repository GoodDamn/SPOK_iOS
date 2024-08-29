//
//  SKModelViewTypeCollection.swift
//  SPOK
//
//  Created by GoodDamn on 28/08/2024.
//

import Foundation
import UIKit

final class SKModelViewTypeCollection
: NSObject, SKModelTypeableView {
    
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
        
        if let it = cell.collectionView {
            it.topics = model.topicIds
            cell.calculateBoundsCollection(
                with: mSize
            )
            it.dataSource = self
            it.delegate = self
        }
        
        return cell
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        (collectionView as? UICollectionViewTopics)?
            .topics?
            .count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let view = collectionView
            as? UICollectionViewTopics else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        guard let topicId = view.topics?[index] else {
            return UICollectionViewCell()
        }
        
        guard let cell = view.dequeueReusableCell(
            withReuseIdentifier: PreviewCell.ID,
            for: indexPath
        ) as? PreviewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.backgroundColor = .gray
        
        return cell
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return MainViewController.mCardSizeM
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDelegate {
    // For flow layout
}
