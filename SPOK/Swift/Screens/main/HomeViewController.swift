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
    
    private var mCollections:[Collection] = [];
    
    private var mSizeb: CGSize = .zero
    
    @IBOutlet weak var colsTable: UITableView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        let w = view.frame.width
        let h = view.frame.height
        
        mSizeb = CGSize(
            width: w * 0.847,
            height: h * 0.226
        )
        
        colsTable.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 25,
            right: 0
        );
        
        
        let down = CollectionDowloader(
            dir: "sleep",
            child: "Sleep"
        )
        down.delegate = self
        
        down.start()
    }
    
    func onFirstCollection(
        c: [Collection]
    ) {
        
    }
    
    func onAdd(i: Int) {
        
    }
    
    func onUpdate(i: Int) {
        
    }
    
    func onRemove(i: Int) {
        
    }
    
}


extension HomeViewController
: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return tableView.rowHeight;
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
        
        cell.selectionStyle = .none;
        cell.nameCollection.text = mCollections[
            indexPath.row
        ].title;
        
        UIView.animate(withDuration: 0.15, animations: {
            cell.nameCollection.alpha = 1.0;
        });
        
        return cell;
    }
}

extension HomeViewController
: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return mSizeb;
    }
    
    
}

/*extension HomeViewController
: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return mCollecti
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let id = collections[collectionView.tag]
            .trs[indexPath.row];
        
        let intID = Int(id);
        
        
        if collectionView.tag == 0 { // is New collection
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bCell", for: indexPath) as! BCellCollectionView;
            cell.collectionView = collectionView;
            cell.load(
                id: intID,
                lang: ""
            );
            return cell;
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "mCell",
            for: indexPath)
            as! MCellCollectionView;
        cell.collectionView = collectionView;
        
        cell.load(
            id: intID,
            lang: "",
            nameSize: 15.0,
            descSize: 8.65
        );
        
        return cell;
    }
}
*/
