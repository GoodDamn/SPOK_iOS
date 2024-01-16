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
    : UIViewController,
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
    
}


extension HomeViewController
: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        
        let c = mCollections[
            indexPath.row
        ]
        
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
        return mCollections.count;
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        (cell as! collectionsCellTableView)
            .collectionView
            .reloadData();
    }
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "collections",
            for: indexPath)
            as! collectionsCellTableView;
        
        
        let col = mCollections[indexPath.row]
        
        let label = cell.nameCollection!
        let colview = cell.collectionView!
        
        colview.tag = indexPath.row
        
        cell.selectionStyle = .none;
        label.text = col.title;
        label.font = label.font
            .withSize(
                col.titleSize
            )
        
        //cell.backgroundColor = .blue
        //colview.backgroundColor = .black
        //label.backgroundColor = .green
        
        colview.dataSource = mColDelegate
        colview.delegate = mColDelegate
        colview.reloadData()
        
        UIView.animate(
            withDuration: 0.15,
            animations: {
                cell.nameCollection
                    .alpha = 1.0;
        });
        
        return cell;
    }
}

extension HomeViewController
    : UITableViewDelegate {
    // For flow layout
}
