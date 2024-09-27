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
    
    var topicType: String? = nil
    var topicName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        let w = view.frame.width
        let h = view.frame.height - mInsets.top
        
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
        
        let textSizeTopicType = 0.4514 * lblTopicName.font
            .pointSize
        
        let lblTopicType = UILabel(
            frame: CGRect(
                x: 0,
                y: textSizeTopicType +
                lblTopicName.frame.bottom(),
                width: w,
                height: 0
            )
        )
        lblTopicType.font = .semibold(
            withSize: textSizeTopicType
        )
        lblTopicType.backgroundColor = .clear
        lblTopicType.text = topicType?.uppercased()
        lblTopicType.textColor = .subtitle()
        lblTopicType.textAlignment = .center
        lblTopicType.sizeToFit()
        lblTopicType.centerH(
            in: view
        )
        
        let sizePlay = 103.nh() * h
        let btnPlay = UIImageView(
            frame: CGRect(
                x: 0,
                y: lblTopicType.frame.bottom() +
                    160.nh() * h,
                width: sizePlay,
                height: sizePlay
            )
        )
        
        btnPlay.image = UIImage(
            systemName: "play"
        )
        btnPlay.tintColor = .accent3()
        btnPlay.backgroundColor = .white
        btnPlay.layer.cornerRadius = btnPlay.height()
            * 0.5
        
        btnPlay.centerH(
            in: view
        )
        
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 118.nh()
        )
        
        btnClose.onClick = { [weak self] v in
            self?.onClickBtnClose(v)
        }
        
        view.addSubview(
            lblTopicName
        )
        
        view.addSubview(
            lblTopicType
        )
        
        view.addSubview(
            btnPlay
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
