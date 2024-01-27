//
//  MainViewController.swift
//  SPOK
//
//  Created by Cell on 19.12.2021.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;

class HomeViewController
    : StackViewController,
      CollectionListener {
    
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
        mDownloader!.delegate = self
        
        mDownloader!.start()
    }
    
    func onFirstCollection(
        c: inout ArrayList<Collection>
    ) {
        mCollections = c

        print(TAG, "onFirstCollection")
               
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
        print(TAG, "onUpdate",i, c.topicsIDs)
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
        let last = mCollections.a[
            mCollections.a.count - 1
        ]
        
        let viewCell = CollectionRowView(
            title: "Счетчик овечек",
            titleSize: last.titleSize,
            height: last.height,
            idCell: SheepViewCell.id
        ) { [weak self] cel in
            
            guard let s = self else {
                print("HomeViewController: viewCell Sheep: GC")
                return
            }
            
            let cell = cel as! SheepViewCell
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
            
            print(s.TAG, "SheepViewCell:", cell.subviews.count)
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
    
    
    @objc func onClickBtnBegin(
        _ sender: UIButton
    ) {
        print(
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


extension HomeViewController
: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let c = mCollections.a[
            indexPath.row
        ]
        print(TAG,
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
            (c as! CollectionRowView)
                .setupView(cel)
            return cel
        }
        
        let cell = cel as!
            CollectionTableViewCell
        
        let colview = cell.collectionView!
        
        let coll = c as! CollectionTopic
        
        cell.selectionStyle = .none;
        
        let del = mColDelegates[r]
        
        if colview.delegate == nil {

            colview.frame.origin.y = label.frame.bottom() + coll.cardSize.height * 0.124
            
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
