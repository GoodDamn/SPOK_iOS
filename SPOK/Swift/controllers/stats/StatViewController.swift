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
    
    private var mSessionId = 0
    
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
        
        getStatRef(
            "didLoad\(mSessionId)"
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
    
    internal func onTerminateApp() {
        Log.d(StatViewController.self, "\(mInstanceName): onTerminateApp:")
        
        getStatRef(
            "terminate\(mSessionId)Time"
        ).increment(
            .currentTimeSec() - mStartTimeSec
        )
        
    }
    
    public final func willTerminate() {
        onTerminateApp()
    }
    
    deinit {
        onTerminateApp()
    }
}
