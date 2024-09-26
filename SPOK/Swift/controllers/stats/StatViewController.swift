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
    
    internal var mSessionId = 0
    
    private let mStartTimeSec: Int = .currentTimeSec()
    
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
        
        mSessionId = UserDefaults.statsKey(
            didLoad
        )
        
        getStatRefId(
            "didLoad"
        ).increment()
    }
    
    internal final func timeIncrement(
        _ child: String
    ) {
        getStatRefId(
            child
        ).increment(
            .currentTimeSec() - mStartTimeSec
        )
    }
    
    internal final func getStatRefId(
        _ child: String
    ) -> DatabaseReference {
        Database.database()
            .reference(
                withPath: getStatChild(
                    "\(child)\(mSessionId)"
                )
            )
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
    
    deinit {
        Log.d(StatViewController.self, "\(mInstanceName): deinit:")
        
        getStatRef(
            "terminate\(mSessionId)Time"
        ).increment(
            .currentTimeSec() - mStartTimeSec
        )
    }
}
