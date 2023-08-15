//
//  ListOfTrainingsViewController.swift
//  SPOK
//
//  Created by Cell on 22.04.2022.
//

import UIKit;
import FirebaseDatabase;

class ListOfTopicsViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!;

    private var tag = "ListOfTopicsViewController:";
    
    var topicViewController:TopicActivity? = nil;
    var index:Int = 0;
    var trs:[UInt16]? = nil;
    var managerVC: ManagerViewController? = nil;
    var delegate: TwoCardRowCollectionViewDelegate = TwoCardRowCollectionViewDelegate();
    
    @IBOutlet weak var leadingCell: NSLayoutConstraint!;
    @IBOutlet weak var trailingCell: NSLayoutConstraint!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        collectionView.delegate = delegate;
        collectionView.dataSource = delegate;
    }
    
    func setTopics(_ t:[UInt16])->Void{
        topicViewController = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "training") as? TopicActivity;
        /*if (index == 0){
            delegate.doShowButtonNothing = true;
        }*/
        trs = t;
        delegate.controller = self;
        delegate.ids = trs!;
        
    }
}

