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
    var topicViewController:TopicActivity? = nil;
    var index:Int = 0;
    private var tag = "List123456: ";
    var trs:[UInt16]? = nil;
    var managerVC: ManagerViewController? = nil;
    var delegate: TwoCardRowCollectionViewDelegate = TwoCardRowCollectionViewDelegate();
    
    @IBOutlet weak var leadingCell: NSLayoutConstraint!;
    @IBOutlet weak var trailingCell: NSLayoutConstraint!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func setTopics(_ t:[UInt16])->Void{
        topicViewController = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "training") as? TopicActivity;
        
        Database.database().reference(withPath: "Trainings").observeSingleEvent(of: .value, with: { [self] 
            snapshot in
            trs = t;
            /*if (index == 0){
                delegate.doShowButtonNothing = true;
            }*/
            delegate.controller = self;
            delegate.ids = trs!;
            collectionView.delegate = delegate;
            collectionView.dataSource = delegate;
        })
        
        
    }
}

