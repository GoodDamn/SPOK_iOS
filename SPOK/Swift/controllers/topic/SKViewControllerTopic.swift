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
    
    var topicId = Int.min {
        didSet {
            mNetworkUrl = "content/skc/\(topicId).mp3"
        }
    }
    
    var topicType: String? = nil
    var topicName: String? = nil
    
    
    private let mServiceContent = SKServiceTopicContent()
    private let mSlider = SKViewSlider()
    private let mLabelCurrentTime = UILabel()
    private let mLabelFinishTime = UILabel()
    private let mLabelMeta = UILabela()
    
    private var mNetworkUrl = ""
    private var mPlayer: AVAudioPlayer? = nil
    private var mTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        mServiceContent.onGetTopicContent = self
        mServiceContent.onProgressDownload = self
        
        let w = view.frame.width
        let h = view.frame.height
        
        let lblTopicName = UILabela(
            frame: CGRect(
                x: 0,
                y: h * 173.nh(),
                width: w,
                height: 0
            )
        )
        lblTopicName.numberOfLines = 0
        lblTopicName.lineHeight = 0.87
        lblTopicName.backgroundColor = .clear
        lblTopicName.font = .extrabold(
            withSize: 31.nw() * w
        )
        lblTopicName.text = topicName
        lblTopicName.textColor = .white
        lblTopicName.textAlignment = .center
        lblTopicName.attribute()
        lblTopicName.sizeToFit()
        let of = lblTopicName.height() * 0.1
        lblTopicName.frame.size.height =
            lblTopicName.height() + of
        lblTopicName.frame.origin.y -= of
        lblTopicName.centerH(
            in: view
        )
        
        let textSizeTopicType = 0.4514 * lblTopicName.font
            .pointSize
        
        let lblTopicType = UILabel(
            frame: CGRect(
                x: 0,
                y: textSizeTopicType * 0.25
                + lblTopicName.frame.bottom(),
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
        
        setupPlayerView(
            w: w,
            h: h
        )
        
        setupSlider(
            w: w,
            h: h
        )
        
        setupBtnClose(
            h: h
        )
        
        let offsetXTime = w * 21.nw()
        setupLabelTime(
            w: w,
            h: h,
            label: mLabelCurrentTime,
            origin: CGPoint(
                x: offsetXTime,
                y: mSlider.bottomy()
            )
        )
        
        setupLabelTime(
            w: w,
            h: h,
            label: mLabelFinishTime,
            origin: CGPoint(
                x: 0,
                y: mSlider.bottomy()
            )
        )
        
        mLabelFinishTime.frame.origin.x = w - mLabelFinishTime
            .frame
            .width - offsetXTime
        
        setupLabelMeta(
            w: w,
            h: h
        )
        
        
        mServiceContent.getContent(
            id: topicId
        )
    }
}


extension SKViewControllerTopic {
    
    private func setupPlayerView(
        w: CGFloat,
        h: CGFloat
    ) {
        let playerView = SKViewPlayer(
            frame: CGRect(
                x: 0,
                y: h * 399.nh(),
                width: w * 292.nw(),
                height: h * 96.nh()
            )
        )
        
        playerView.onClickPlay = {
            [weak self] v in
            self?.onClickBtnPlay(
                playerView: playerView
            )
        }
        
        playerView.onClickBack = {
            [weak self] v in
            self?.onClickBtnBack()
        }
        
        playerView.onClickNext = {
            [weak self] v in
            self?.onClickBtnNext()
        }
        
        playerView.centerH(
            in: view
        )
        
        view.addSubview(
            playerView
        )
    }
    
    private func setupLabelMeta(
        w: CGFloat,
        h: CGFloat
    ) {
        mLabelMeta.frame = CGRect(
            x: 0,
            y: h * 799.nh(),
            width: w,
            height: 0
        )
        
        mLabelMeta.leftImage = UIImage(
            systemName: "music.note"
        )
        
        mLabelMeta.textColor = .white
            .withAlphaComponent(0.6)
        
        mLabelMeta.leftImageColor = mLabelMeta
            .textColor
        
        mLabelMeta.font = .semibold(
            withSize: w * 18.nw()
        )
        
        view.addSubview(
            mLabelMeta
        )
    }
    
    private func setupLabelTime(
        w: CGFloat,
        h: CGFloat,
        label: UILabel,
        origin: CGPoint
    ) {
        label.frame = CGRect(
            origin: origin,
            size: .zero
        )
        label.text = "00:00"
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .semibold(
            withSize: h * 16.nh()
        )
        
        label.sizeToFit()
        
        view.addSubview(
            label
        )
    }
    
    private func setupSlider(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 333.nw()
        let hh = h * 50.nh()
        
        let slider = mSlider
        slider.frame = CGRect(
            x: 0,
            y: h * 688.nh(),
            width: ww,
            height: hh
        )
        
        slider.backgroundColor = .clear
        slider.progress = 0.0
        slider.strokeWidth = slider.height() * 0.1
        slider.radius = slider.height() * 0.15
        slider.trackColor = (
            UIColor.clock() ?? .black
        ).cgColor
        
        slider.backgroundProgressColor = UIColor
            .white
            .withAlphaComponent(
                0.15
            ).cgColor
        
        slider.progressColor = (
            UIColor.accent2() ?? .white
        ).cgColor
        
        slider.onChangeProgress = self
        
        slider.isUserInteractionEnabled = false
        
        slider.centerH(
            in: view
        )
        
        view.addSubview(
            slider
        )
        
    }
    
    private func setupBtnClose(
        h: CGFloat
    ) {
        let btnClose = ViewUtils.buttonClose(
            in: view,
            sizeSquare: 118.nh(),
            iconProp: 0.2
        )
        
        btnClose.frame.origin.y = h * 60.nh()
        
        btnClose.tintColor = .white
        btnClose.backgroundColor = .clear
        btnClose.onClick = { [weak self] v in
            self?.onClickBtnClose(v)
        }
        
        view.addSubview(
            btnClose
        )
    }
    
    private func setupDeformCircle2(
        w: CGFloat,
        h: CGFloat
    ) {
        let ww = w * 243.nw()
        let f = ww
        let hh = ww
        
        let strokeColor = (
            UIColor.deform() ?? .black
        ).cgColor
        
        let v = SKViewDeform(
            frame: CGRect(
                x: w - ww * 0.8,
                y: h - hh,
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
                        x: 0.8,
                        y: 0.25
                    )
                ],
                move: CGPoint(
                    x: 0.8 * ww,
                    y: 0.25 * hh
                ),
                strokeColor: strokeColor,
                strokeWidth: f * 0.2,
                radius: f * 0.4,
                startAngle: .pi * -1.2,
                endAngle: .pi * -0.25
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
    
    private func onClickBtnNext() {
        print("next")
    }
    
    private func onClickBtnBack() {
        print("back")
    }
    
    private func onClickBtnPlay(
        playerView: SKViewPlayer
    ) {
        guard let player = mPlayer else {
            return
        }
        
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        
        playerView.isPlaying = player.isPlaying
        
    }
    
    private func onClickBtnClose(
        _ v: UIView
    ) {
        mPlayer?.stop()
        mTimer?.invalidate()
        popBaseAnim()
    }
    
    @objc private func onTickPlayer() {
        guard let player = mPlayer else {
            return
        }
        mSlider.progress = player.currentTime / player.duration
        mSlider.setNeedsDisplay()
        
        mLabelCurrentTime.text = player
            .currentTime
            .toTimeString()
    }
    
}

extension SKViewControllerTopic
: SKIListenerOnChangeProgress {
    
    func onChangeProgress(
        progress: CGFloat
    ) {
        guard let player = mPlayer else {
            return
        }
        
        player.currentTime = TimeInterval(
            progress
        ) * player.duration
    }
    
}

extension SKViewControllerTopic
: SKDelegateOnGetTopicContent {
    
    func onGetTopicContent(
        model: SKModelTopicContent
    ) {
        if model.data == nil {
            return
        }
        
        do {
            guard var dd = model.data else {
                return
            }
            let player = try AVAudioPlayer(
                data: dd,
                fileTypeHint: AVFileType.mp3.rawValue
            )
            player.prepareToPlay()
            
            player.setVolume(
                1.0,
                fadeDuration: 0.1
            )
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
            
            mLabelFinishTime.text = player
                .duration
                .toTimeString()
            
            mLabelFinishTime.sizeToFit()
            
            if let meta = AVAsset.mp3Meta(
                from: &dd
            ) {
                mLabelMeta.text = " \(meta.artist) - \(meta.title)"
                mLabelMeta.attribute()
                mLabelMeta.sizeToFit()
                mLabelMeta.centerH(
                    in: view
                )
            }
            
            mPlayer = player
            
            mTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(
                    onTickPlayer
                ),
                userInfo: nil,
                repeats: true
            )
            
        } catch {
            Log.d(
                "onGetTopicContent: ERROR", error
            )
        }
        
        mSlider.isUserInteractionEnabled = true
        mSlider.progress = 0
        mSlider.setNeedsDisplay()
    }
    
}

extension SKViewControllerTopic
: SKDelegateOnProgressDownload {
    
    func onProgressDownload(
        progress: CGFloat
    ) {
        mSlider.progress = progress
        mSlider.setNeedsDisplay()
    }
    
}
