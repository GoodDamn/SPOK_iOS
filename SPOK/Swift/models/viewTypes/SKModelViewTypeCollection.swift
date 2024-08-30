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
        
        guard let viewModel = model as? SKModelTableViewCollection else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "0",
            for: indexPath
        ) as? UITableViewCellCollection else {
            return UITableViewCell()
        }
        
        cell.mTitle?.text = viewModel.model.title
        
        cell.calculateBoundsTitle(
            with: mSize
        )
        
        if let it = cell.collectionView {
            it.topics = viewModel.model.topicIds
            it.topicSize = viewModel.cardSize
            it.cardType = viewModel.model.cardType
            it.cardTextSize = viewModel.cardTextSize
            cell.calculateBoundsCollection(
                with: mSize
            )
            it.insetsSection.left = it.contentInset.right
            it.dataSource = self
            it.delegate = self
        }
        
        return cell
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDataSource {
    
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        (collectionView as? UICollectionViewTopics)?
            .topics?
            .count ?? 0
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let view = collectionView
            as? UICollectionViewTopics else {
            return UICollectionViewCell()
        }
        let index = indexPath.section
        guard let topicId = view.topics?[index] else {
            return UICollectionViewCell()
        }
        
        guard let cell = view.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCellTopic.ID,
            for: indexPath
        ) as? UICollectionViewCellTopic else {
            return UICollectionViewCell()
        }
                
        cell.alpha = 0.0
        
        cell.stopParticles()
        
        cell.layout(
            with: view.topicSize
        )
        
        cell.cardTextSize = view.cardTextSize
        
        cell.loadData(
            previewId: Int(topicId),
            type: view.cardType
        )
        
        return cell
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        (collectionView as? UICollectionViewTopics)?
            .insetsSection ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        (collectionView as? UICollectionViewTopics)?
            .topicSize ?? .zero
    }
    
}

extension SKModelViewTypeCollection
: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        (cell as? UICollectionViewCellTopic)?
            .onDidEndDisplaying()
    }
    
}
