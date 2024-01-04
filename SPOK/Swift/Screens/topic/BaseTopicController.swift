//
//  BaseTopicController.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import UIKit

class BaseTopicController
    : UIViewController {
    
    private final let TAG = "BaseTopicController:"
    
    private let mEngine =
        SPOKContentEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(
            named: "background")
        
        let fm = FileManager.default
        
        let url = fm
            .urls(
                for: .cachesDirectory,
                in: .userDomainMask)[0]
        
        let urlSkc = url
            .appendingPathComponent(
                "14.skc"
            )
        
        print(TAG, "PATH_SKC:",urlSkc)
        
        guard let data = fm.contents(
            atPath: urlSkc.path
        ) else {
            print(TAG, "INVALID_PATH_SKC")
            return
        }
        
        mEngine.loadResources(
            dataSKC: [UInt8](data))
    }
    
}
