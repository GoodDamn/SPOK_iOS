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
        
        btnPlay.image = mImagePlay
        btnPlay.scale = CGPoint(
            x: 0.65,
            y: 0.65
        )
        btnPlay.tintColor = .accent3()
        btnPlay.backgroundColor = .accent2()
        btnPlay.layer.cornerRadius = btnPlay
            .height() * 0.5
        btnPlay.clipsToBounds = true
        
        btnPlay.centerH(
            in: view
        )
        
        setupDeformView(
            w: w,
            h: h
        )
        
        setupDeformCircle(
            w: w,
            h: h
        )
        
        setupDeformCircle2(
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
        
        setupSlider(
            w: w,
            h: h
        )
        
        setupBtnClose()
        
        mServiceContent.getContentUrlAsync(
            id: topicId
        )
    }
}


extension SKViewControllerTopic {
    
    private func setupSlider(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 333.nw()
        let hh = h * 50.nh()
        
        let slider = SKViewSlider(
            frame: CGRect(
                x: 0,
                y: h * 0.75,
                width: ww,
                height: hh
            )
        )
        
        slider.backgroundColor = .clear
        
        slider.strokeWidth = slider.height() * 0.1
        slider.radius = slider.height() * 0.17
        slider.trackColor = (
            UIColor.clock() ?? .black
        ).cgColor
        
        slider.centerH(
            in: view
        )
        
        view.addSubview(
            slider
        )
        
    }
    
    private func setupBtnClose() {
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 118.nh(),
            iconProp: 0.2
        )
        
        btnClose.tintColor = .accent3()
        btnClose.backgroundColor = .accent2()
        btnClose.onClick = { [weak self] v in
            self?.onClickBtnClose(v)
        }
        
        btnClose.layer.cornerRadius = btnClose
            .height() * 0.5
        
        btnClose.clipsToBounds = true
        
        view.addSubview(
            btnClose
        )
    }
    
    private func setupDeformCircle2(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 243.nw()
        let hh = h * 233.nh()
        
        let f = ww > hh ? hh : ww
        
        let strokeColor = (
            UIColor.deform() ?? .black
        ).cgColor
        
        let v = SKViewDeform(
            frame: CGRect(
                x: w - ww * 0.5,
                y: h - hh * 0.75,
                width: ww,
                height: hh
            )
        )
        
        v.isFillPath = false
        v.alpha = 0.5
        
        v.quads = [
            SKShapeArc(
                points: [
                    CGPoint(
                        x: 0.4,
                        y: 0.25
                    )
                ],
                move: CGPoint(
                    x: 0.4 * ww,
                    y: 0.25 * hh
                ),
                strokeColor: strokeColor,
                strokeWidth: f * 0.2,
                radius: f * 0.4,
                startAngle: .pi * 1.05,
                endAngle: .pi * 1.35
            )
        ]
        
        view.addSubview(v)
        v.backgroundColor = .clear
    }
    
    private func setupDeformCircle(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 192.nw()
        let hh = h * 174.nh()
        
        let f = ww > hh ? hh : ww
        
        let v = SKViewDeform(
            frame: CGRect(
                x: 0,
                y: h-hh*0.8,
                width: ww,
                height: hh
            )
        )
        
        let strokeColor = (
            UIColor.deform() ?? .black
        ).cgColor
        
        v.isFillPath = false
        
        v.quads = [
            SKShapeArc(
                points: [
                    CGPoint(
                        x: 0,
                        y: 1.0
                    )
                ],
                move: CGPoint(
                    x: 0,
                    y: hh
                ),
                strokeColor: strokeColor,
                strokeWidth: f * 0.4,
                radius: f * 0.8,
                startAngle: 0,
                endAngle: .pi / 2
            )
        ]
        
        view.addSubview(v)
        
        v.backgroundColor = .clear
    }
    
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
        let fillColor = (
            UIColor.deform() ?? .systemBlue
        ).cgColor
        
        deformView.isFillPath = true
        
        deformView.quads = [
            SKShapeBezierQ(
                points: [
                    CGPoint(
                        x: 0.66,
                        y: 0
                    ),
                    CGPoint(
                        x: 0.2838,
                        y: 0
                    )
                ],
                move: CGPoint(
                    x: ww,
                    y: 0
                ),
                fillColor: fillColor
            ),
            SKShapeBezierQ(
                points: [
                    CGPoint(
                        x: 0.2455,
                        y: 0.1217
                    ),
                    CGPoint(
                        x: 0.1333,
                        y: 0.2371
                    )
                ],
                fillColor: fillColor
            ),
            SKShapeBezierQ(
                points: [
                    CGPoint(
                        x: -0.0969,
                        y: 0.5032
                    ),
                    CGPoint(
                        x: 0.0792,
                        y: 0.7211
                    )
                ],
                fillColor: fillColor
            ),
            SKShapeBezierQ(
                points: [
                    CGPoint(
                        x: 0.4581,
                        y: 1.1057
                    ),
                    CGPoint(
                        x: 1.0,
                        y: 0.955
                    )
                ],
                fillColor: fillColor
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
