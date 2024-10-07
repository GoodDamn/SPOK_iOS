//
//  SKViewControllerTopic.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import AVFoundation
import AVKit
import UIKit

final class SKViewControllerTopic
: StackViewController {
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private let mServiceContent = SKServiceTopicContent()
    
    private var mNetworkUrl = ""
    
    var topicId = Int.min {
        didSet {
            mNetworkUrl = "content/skc/\(topicId).mp3"
        }
    }
    
    var topicType: String? = nil
    var topicName: String? = nil
    
    private let mImagePlay = UIImage(
        systemName: "play.fill"
    )
    
    private let mImagePause = UIImage(
        systemName: "pause.fill"
    )
    
    private var mIsPlaying = true
    
    private var mPlayer: AVPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        mServiceContent.onGetTopicUrl = self
        
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
        lblTopicName.text = (topicName ?? "") + " \(topicId)"
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
        let btnPlay = UIImageButton(
            frame: CGRect(
                x: 0,
                y: lblTopicType.frame.bottom() +
                    160.nh() * h,
                width: sizePlay,
                height: sizePlay
            )
        )
        
        btnPlay.onClick = { [weak self] v in
            guard let v = v as? UIImageButton else {
                return
            }
            self?.onClickBtnPlay(v)
        }
        
        btnPlay.image = UIImage(
            systemName: "play.fill"
        )
        btnPlay.scale = CGPoint(
            x: 0.65,
            y: 0.65
        )
        btnPlay.tintColor = .accent3()
        btnPlay.backgroundColor = .white
        btnPlay.layer.cornerRadius = btnPlay.height()
            * 0.5
        btnPlay.clipsToBounds = true
        
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
        
        setupDeformView(
            w: w,
            h: h
        )
        
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
        
        mServiceContent.getContentUrlAsync(
            id: topicId
        )
    }
}


extension SKViewControllerTopic {
    
    private func setupDeformView(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 0.6
        let hh = h * 0.4
        let deformView = SKViewDeform(
            frame: CGRect(
                x: w-ww,
                y: 0,
                width: ww,
                height: hh
            )
        )
        
        deformView.quads = [
            SKModelDeformQuad(
                from: CGPoint(
                    x: ww,
                    y: 0
                ),
                control: CGPoint(
                    x: 0,
                    y: hh * 0.5
                ),
                to: CGPoint(
                    x: 0,
                    y: hh
                )
            ),
            SKModelDeformQuad(
                from: CGPoint(
                    x: 0,
                    y: hh
                ),
                control: CGPoint(
                    x: ww,
                    y: hh * 0.5
                ),
                to: CGPoint(
                    x: ww,
                    y: 0
                )
            )
        ]
        
        view.addSubview(
            deformView
        )
        
        deformView.backgroundColor = .clear
        
    }
    
    private func onClickBtnPlay(
        _ v: UIImageButton
    ) {
        mIsPlaying = !mIsPlaying
        
        if mIsPlaying {
            v.image = mImagePlay
            mPlayer?.pause()
        } else {
            v.image = mImagePause
            mPlayer?.play()
        }
        
        v.setNeedsDisplay()
    }
    
    private func onClickBtnClose(
        _ v: UIView
    ) {
        if let it = mPlayer {
            it.pause()
            it.replaceCurrentItem(
                with: nil
            )
        }
        popBaseAnim()
    }
    
}

extension SKViewControllerTopic
: SKListenerOnGetContentUrl {
    
    func onGetContentUrl(
        url: URL
    ) {
        let item = AVPlayerItem(
            url: url
        )
        
        mPlayer = AVPlayer(
            playerItem: item
        )
        
    }
}
