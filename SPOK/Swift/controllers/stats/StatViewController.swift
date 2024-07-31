//
//  StatViewController.swift
//  SPOK
//
//  Created by GoodDamn on 31/07/2024.
//

import FirebaseDatabase
import UIKit.UIViewController

class StatViewController
    : UIViewController {
    
    internal final let mInstanceName: String
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        mInstanceName = "\(type(of: self))"
        super.init(
            nibName: nibNameOrNil,
            bundle: nibBundleOrNil
        )
    }
    
    required init?(
        coder: NSCoder
    ) {
        mInstanceName = "\(type(of: self))"
        super.init(
            coder: coder
        )
    }
    
    override func viewDidLoad() {
        let didLoad = "\(mInstanceName):didLoad"
        UserDefaults.statsInc(
            didLoad
        )
        
        let n = UserDefaults.statsKey(
            didLoad
        )
        
        getStatRef(
            "didLoad\(n)"
        ).increment()
    }
    
    
    internal final func getStatRef(
        _ child: String
    ) -> DatabaseReference {
        Database.database()
            .reference(
                withPath: getStatChild(
                    child
                )
            )
    }

    internal final func getStatChild(
        _ child: String
    ) -> String {
        "stats/screens/\(mInstanceName)/\(child)"
    }
}
