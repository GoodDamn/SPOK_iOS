//
//  SKViewControllerTopic.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import AVFoundation
import UIKit

final class SKViewControllerTopic
: StackViewController {
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private let mServiceContent = SKServiceTopicContent()
    
    private var mNetworkUrl = ""
    
    var topicId = Int.min {
        didSet {
            mNetworkUrl = "content/skc/\(topicId).skc"
        }
    }
    
    var topicName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        let w = view.frame.width
        let h = view.frame.height
        
        let lblTopicName = UILabel(
            frame: CGRect(
                x: 0,
                y: mInsets.top + h * 160.nh(),
                width: w,
                height: 0
            )
        )
        lblTopicName.numberOfLines = 0
        lblTopicName.backgroundColor = .clear
        lblTopicName.font = .extrabold(
            withSize: 34.nw() * w
        )
        lblTopicName.text = topicName
        lblTopicName.textColor = .white
        lblTopicName.textAlignment = .center
        lblTopicName.sizeToFit()
        lblTopicName.centerH(
            in: view
        )
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 59.nh() * h
        )
        
        btnClose.onClick = { [weak self] v in
            self?.onClickBtnClose(v)
        }
        
        view.addSubview(
            lblTopicName
        )
        
        view.addSubview(
            btnClose
        )
        
    }
}


extension SKViewControllerTopic {
    
    private func onClickBtnClose(
        _ v: UIView
    ) {
        popBaseAnim()
    }
    
}
