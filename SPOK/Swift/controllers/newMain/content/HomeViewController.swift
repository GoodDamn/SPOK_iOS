//
//  MainViewController.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit;

final class HomeViewController
: StackViewController {
    
    private let TAG = "HomeViewController:"
    private let mServiceCollection = SKServiceCollection()
    
    private var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        let w = view.frame.width
        let h = view.frame.height - mInsets.bottom - 50 // 50 - nav bar (MainContentViewController)
        
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
        
        mTableView = UITableView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: w,
                height: h
            )
        )
        
        mTableView.separatorStyle = .none
        
        mTableView.register(
            CollectionTableViewCell.self,
            forCellReuseIdentifier:
                CollectionTableViewCell.id
        )
        
        mTableView.register(
            SheepViewCell.self,
            forCellReuseIdentifier:
                SheepViewCell.id
        )
        
        mTableView.contentInset = UIEdgeInsets(
            top: mInsets.top == 0 ? h * 0.1 : 0,
            left: 0,
            bottom: 25,
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
        openPremiumTopics(
            mTableView
        )
    }
    
}

extension HomeViewController {
    
    private func onClickBtnBegin(
        _ sender: UIView
    ) {
        Log.d(
            TAG,
            "onClickBtnBegin:"
        )
        let c = SheepCounterViewController()
        c.view.alpha = 0
        
        push(
            c,
            animDuration: 0.5
        ) {
            c.view.alpha = 1.0
        }
    }
    
    private func openPremiumTopics(
        _ inp: UIView
    ) {
        
        if let previewCell =
            inp as? PreviewCell {

            guard let part = previewCell.mParticles else {
                return
            }

            Log.d(
                TAG,
                "PreviewCell: DETECTED:",
                previewCell.mTitle.text
            )
            
            part.stop()
            part.isHidden = true
            
            return
        }
        
        for i in inp.subviews {
            openPremiumTopics(i)
        }
    }
}

extension HomeViewController
: SKDelegateCollection {
    
    
    func onGetCollections(
        collections: inout [SKModelCollection]
    ) {
        //mTableView.dataSource = self
        //mTableView.delegate = self
        //mTableView.reloadData()
    }
    
}

extension HomeViewController
    : UITableViewDelegate {
    // For flow layout
}
