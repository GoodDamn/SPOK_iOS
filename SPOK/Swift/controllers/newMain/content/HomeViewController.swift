//
//  MainViewController.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit;

final class HomeViewController
    : StackViewController {
    
    private let TAG = "HomeViewController:";
    
    private var mTableView: UITableView!
    
    private var mDownloader: CollectionDowloader? = nil
    
    private var mCollections: ArrayList<Collection> = ArrayList()
    private var mColDelegates: [CollectionDelegate] = []
    
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
        
        mDownloader = CollectionDowloader(
            dir: "sleep",
            child: "Sleep"
        )
        mDownloader!
            .delegateCollection = self
        
        mDownloader!.start()
        
    }
    
    override func onUpdatePremium() {
        openPremiumTopics(
            mTableView
        )
    }
    
    @objc func onClickBtnBegin(
        _ sender: UIButton
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
    
}

extension HomeViewController {
    
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
    : CollectionListener {
    
    func onFirstCollection(
        c: inout ArrayList<Collection>
    ) {
        mCollections = c

        Log.d(TAG, "onFirstCollection")
               
        for i in mCollections.a.indices {
            mColDelegates.append(
                CollectionDelegate(
                    collection: c.a[i] as! CollectionTopic
                )
            )
        }
        
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.reloadData()
    }
    
    func onAdd(i: Int) {
        mColDelegates.append(
            CollectionDelegate(
                collection: mCollections.a[i] as! CollectionTopic
            )
        )
        mTableView.insertRows(
            at: [
                IndexPath(
                    row: i,
                    section: 0
                )
            ],
            with: .left)
    }
    
    func onUpdate(i: Int) {
        let c = mCollections.a[i] as! CollectionTopic
        
        Log.d(
            TAG,
            "onUpdate",
            i,
            c.topicsIDs
        )
        
        mColDelegates[i]
            .setCollection(
                c
            )
        
        mTableView.reloadRows(
            at: [
                IndexPath(
                    row: i,
                    section: 0
                )
            ],
            with: .fade)
    }
    
    func onRemove(i: Int) {
        mColDelegates.remove(
            at: i
        )
        mTableView.deleteRows(
            at: [
                IndexPath(
                    row: i,
                    section: 0
                )
            ],
            with: .fade
        )
    }
    
    func onFinish() {
        mDownloader = nil
        
        let colCount = mCollections.a.count
        
        var titleSize: CGFloat = 18
        var heightCell: CGFloat = 250
        
        if colCount != 0 {
            let last = mCollections.a[
                colCount - 1
            ]
            
            titleSize = last.titleSize
            heightCell = last.height
        }
        
        let viewCell = CollectionRowView(
            title: "Счетчик овечек",
            titleSize: titleSize,
            height: heightCell,
            idCell: SheepViewCell.id
        ) { [weak self] cel in
            
            guard let s = self else {
                Log.d("HomeViewController: viewCell Sheep: GC")
                return
            }
            
            guard let cell = cel as? SheepViewCell else {
                return
            }
            
            cell.backgroundColor = .clear
            
            cell.mBtnBegin?
                .addTarget(
                    self,
                    action: #selector(
                        s.onClickBtnBegin(
                            _:
                        )
                    ),
                    for: .touchUpInside
                )
            
            Log.d(s.TAG, "SheepViewCell:", cell.subviews.count)
        }
        
        mCollections.a.append(
            viewCell
        )
        
        mTableView.insertRows(
            at: [
                IndexPath(
                    row: mCollections
                        .a
                        .count-1,
                    section: 0
                )
            ],
            with: .left)
    }
}

extension HomeViewController
    : UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let c = mCollections.a[
            indexPath.row
        ]
        Log.d(TAG,
              "heightForRowAt:",
              c.height
        )
        return c.height;
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return mCollections.a.count;
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let r = indexPath.row
                
        let c = mCollections.a[r]
        
        guard let cel = tableView.dequeueReusableCell(
            withIdentifier: c.idCell
        ) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        
        let label = cel.mTitle!
        label.text = c.title;
        label.font = label.font
            .withSize(
                c.titleSize
            )
        
        label.sizeToFit()
        
        if cel as? SheepViewCell != nil {
            (c as? CollectionRowView)?
                .setupView(cel)
            return cel
        }
        
        guard let cell = cel as?
                CollectionTableViewCell else {
            return UITableViewCell()
        }
        
        guard let colview = cell.collectionView else {
            return UITableViewCell()
        }
        
        guard let coll = c as? CollectionTopic else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none;
        
        let del = mColDelegates[r]
        
        if colview.delegate == nil {

            colview.frame.origin.y = label.frame.bottom() + (cell.mTitle?.font.pointSize ?? 0)
            
            colview.frame.size = CGSize(
                width: view.frame.width,
                height: coll.cardSize.height
            )
            
            del.registerCells(
                for: colview
            )
            
            colview.dataSource = del
            colview.delegate = del
        }
        
        UIView.animate(
            withDuration: 0.15,
            animations: {
                label.alpha = 1.0;
        });
        
        return cell;
    }
}

extension HomeViewController
    : UITableViewDelegate {
    // For flow layout
}
