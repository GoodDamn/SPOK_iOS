//
//  UIViewControllerHome.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit

final class UIViewControllerHome
: StackViewController {
    
    private let TAG = "UIViewControllerHome:"
    private let mServiceCollection = SKServiceCollection()
    
    private var mTableView: UITableViewTypeable!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        let w = view.frame.width
        let h = view.frame.height - mInsets.bottom - 50
            // 50 - nav bar (MainContentViewController)
        
        let wmoon = 0.594 * w
        let hmoon = 0.533 * w
        
        let ivMoon = UIImageView(
            frame: CGRect(
                x: w-wmoon+0.03*w,
                y: h * -0.019,
                width: wmoon,
                height: hmoon
            )
        )
        
        ivMoon.backgroundColor = .clear
        ivMoon.image = UIImage(
            named: "moon"
        )
        
        let colHeight = w * 265.nw()
        
        let typeCollection = SKModelViewTypeCollection(
            size: CGSize(
                width: w,
                height: colHeight
            )
        )
        typeCollection.onSelectTopic = self
        
        mTableView = UITableViewTypeable(
            frame: CGRect(
                origin: .zero,
                size: view.frame.size
            ),
            viewTypes: [
                typeCollection,
                SKModelViewTypeSheep(
                    size: CGSize(
                        width: w,
                        height: w * 283.nw()
                    )
                )
            ]
        )
        
        mTableView.space = colHeight * 0.02
        
        mTableView.separatorStyle = .none
        mTableView.contentInset = UIEdgeInsets(
            top: mInsets.top == 0 ? h * 0.05 : 0,
            left: 0,
            bottom: h * 0.1,
            right: 0
        );
        
        mTableView.backgroundColor = .clear
        mTableView.showsHorizontalScrollIndicator = false
        mTableView.showsVerticalScrollIndicator = false
        
        view.addSubview(
            ivMoon
        )
        
        view.addSubview(
            mTableView
        )
        
        mServiceCollection.delegate = self
        mServiceCollection.getCollectionAsync()
    }
    
    override func onUpdatePremium() {
        managePremiumTopics(
            mTableView
        )
    }
    
}

extension UIViewControllerHome {
    private func managePremiumTopics(
        _ inp: UIView
    ) {
        
        if let previewCell = inp as? UICollectionViewCellTopic {
            previewCell.stopParticles()
            
            if SKViewControllerMain.mIsPremiumUser {
                return
            }
            
            if previewCell.isPremiumTopic {
                previewCell.startParticles()
            }
            return
        }
        
        for i in inp.subviews {
            managePremiumTopics(i)
        }
    }
}

extension UIViewControllerHome
: SKIListenerOnSelectTopic {
    
    func onSelectTopic(
        preview: SKModelTopicPreview?,
        collection: SKModelCollection?,
        id: UInt16
    ) {
        if (preview?.isPremium ?? true) && !SKViewControllerMain
            .mIsPremiumUser {
            // Move to sub page
            Toast.show(
                text: "Доступно только с подпиской"
            )
            return
        }
        
        let t = SKViewControllerTopic()
        t.topicId = id
        t.collection = collection
        t.topicName = preview?.title
        t.view.alpha = 0.0
        
        UIApplication.main().push(
            t,
            animDuration: 0.3
        ) { [weak self] in
            t.view.alpha = 1.0
        }
    }
    
}

extension UIViewControllerHome
: SKDelegateCollection {
    
    func onGetCollections(
        collections: inout [SKModelCollection]
    ) {
        var viewable = Array<SKModelTypeable>()
        let n = collections.count + 1
        viewable.reserveCapacity(n)
        
        var cardTextSize: CardTextSize
        var cardSize: CGSize
        
        for i in 0..<collections.count {
            
            let col = collections[i]
            
            switch (col.cardType) {
            case .M:
                cardTextSize = SKViewControllerMain.mCardTextSizeM
                cardSize = SKViewControllerMain.mCardSizeM
            default:
                cardTextSize = SKViewControllerMain.mCardTextSizeB
                cardSize = SKViewControllerMain.mCardSizeB
            }
            
            viewable.append(
                SKModelTypeable(
                    model: SKModelTableViewCollection(
                        model: col,
                        cardTextSize: cardTextSize,
                        cardSize: cardSize
                    ),
                    viewType: 0
                )
            )
        }
        
        viewable.append(
            SKModelTypeable(
                viewType: 1
            )
        )
        
        
        mTableView.models = viewable
        mTableView.reloadData()
    }
}
