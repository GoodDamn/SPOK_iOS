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
    
    @IBOutlet weak var colsTable: UITableView!;
    
    private var mDownloader: CollectionDowloader? = nil
    
    private var mCollections:[Collection] = [];
    private var mColDelegate = CollectionDelegate()
        
    override func viewDidLoad() {
        super.viewDidLoad();
    
        let w = view.frame.width
        let h = view.frame.height
        
        colsTable.register(
            SheepViewCell.self,
            forCellReuseIdentifier: SheepViewCell.id)
        
        colsTable.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 25,
            right: 0
        );
        
        mDownloader = CollectionDowloader(
            dir: "sleep",
            child: "Sleep"
        )
        mDownloader!.delegate = self
        
        mDownloader!.start()
    }
    
    func onFirstCollection(
        c: inout [Collection]
    ) {
        print(TAG, "onFirstCollection")
        mCollections = c
        mColDelegate.setCollections(c)
        colsTable.dataSource = self
        colsTable.delegate = self
        colsTable.reloadData()
    }
    
    func onAdd(i: Int) {
        colsTable.insertRows(
            at: [
                IndexPath(
                    row: i,
                    section: 0
                )
            ],
            with: .left)
    }
    
    func onUpdate(i: Int) {
        colsTable.reloadRows(
            at: [
                IndexPath(
                    row: i,
                    section: 0
                )
            ],
            with: .fade)
    }
    
    func onRemove(i: Int) {
        colsTable.deleteRows(
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
        
        if indexPath.row >= mCollections.count {
            return 300
        }
        
        let c = mCollections[
            indexPath.row
        ] as! CollectionTopic
        
        let a = c.height +
            c.cardSize.height * 0.193 +
            c.cardSize.height * 0.124
        
        print(TAG, "heightForRowAt:",c.height, a)
        
        return a;
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return mCollections.count + 1;
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
    }
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let r = indexPath.row
                
        if r == mCollections.count {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SheepViewCell.id
            ) as! SheepViewCell
            
            cell.backgroundColor = .clear
            
            cell.mTitle?.text = "Счетчик овечек"
            
            cell.mTitle?.sizeToFit()
            cell.mBtnBegin?
                .addTarget(
                    self,
                    action: #selector(
                        onClickBtnBegin(_:)
                    ),
                    for: .touchUpInside
                )
            
            print(TAG, "SheepViewCell:", cell.subviews.count)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "collections",
            for: indexPath)
            as! CollectionTableViewCell;
        
        
        let col = mCollections[indexPath.row]
            as! CollectionTopic
        
        let label = cell.mTitle!
        let colview = cell.collectionView!
        
        colview.tag = indexPath.row
        
        cell.selectionStyle = .none;
        label.text = col.title;
        label.font = label.font
            .withSize(
                col.titleSize
            )
        
        label.sizeToFit()
        
        print(TAG,"LFRAME:",label.frame)
        
        colview.dataSource = mColDelegate
        colview.delegate = mColDelegate
        colview.reloadData()
        
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
