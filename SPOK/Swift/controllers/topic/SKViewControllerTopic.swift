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
    
    var topicId = UInt16.min {
        didSet {
            mNetworkUrl = "content/skc/\(topicId).mp3"
        }
    }
    
    var collection: SKModelCollection? = nil
    var topicName: String? = nil
    
    private var observerPlayerStatus: NSKeyValueObservation? = nil
    
    private var mPrevTopicIds: [UInt16] = []
    
    private let mServiceContent = SKServiceTopicContent()
    private let mServicePreview = SKServiceTopicPreviews()
    
    private let mLabelTopicName = UILabela()
    private let mLabelTopicType = UILabel()
    private let mSlider = SKViewSlider()
    private let mLabelCurrentTime = UILabel()
    private let mLabelFinishTime = UILabel()
    private var mViewPlayer: SKViewPlayer? = nil
    
    private var mNetworkUrl = ""
    private var mPlayer: SKPlayerAudio? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background()
        
        mServiceContent.onGetTopicUrl = self
        mServiceContent.onFail = self
        
        mServicePreview.delegate = self
        
        let w = view.frame.width
        let h = view.frame.height
        
        mLabelTopicName.numberOfLines = 0
        mLabelTopicName.lineHeight = 0.87
        mLabelTopicName.backgroundColor = .clear
        mLabelTopicName.textColor = .white
        mLabelTopicName.textAlignment = .center
        calculateLabelName()
        
        mLabelTopicName.text = .locale(
            "loading"
        )
        
        mLabelTopicName.sizeToFit()
        mLabelTopicName.centerH(
            in: view
        )
        
        mLabelTopicType.backgroundColor = .clear
        mLabelTopicType.textColor = .subtitle()
        mLabelTopicType.textAlignment = .center
        calculateLabelType()
        
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
            mLabelTopicName
        )
        
        view.addSubview(
            mLabelTopicType
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
        
        forEachView { it in
            it.isUserInteractionEnabled = false
        }
        
        mServiceContent.getContentUrlAsync(
            id: topicId
        )
    }
}


extension SKViewControllerTopic {
    
    private func calculateLabelName() {
        let w = view.frame.width
        let h = view.frame.height
        
        mLabelTopicName.frame = CGRect(
            x: 0,
            y: h * 173.nh(),
            width: w,
            height: 0
        )
        
        mLabelTopicName.font = .extrabold(
            withSize: 31.nw() * w
        )
        
        let of = mLabelTopicName.height() * 0.1
        mLabelTopicName.frame.size.height = mLabelTopicName.height() + of
        mLabelTopicName.frame.origin.y -= of
        
        mLabelTopicName.text = topicName
        mLabelTopicName.sizeToFit()
        mLabelTopicName.centerH(
            in: view
        )
    }
    
    private func calculateLabelType() {
        let w = view.frame.width
        
        let textSizeTopicType = 0.4514 * mLabelTopicName.font
            .pointSize
        
        mLabelTopicType.frame = CGRect(
            x: 0,
            y: textSizeTopicType * 0.25
            + mLabelTopicName.frame.bottom(),
            width: w,
            height: 0
        )
        
        mLabelTopicType.font = .semibold(
            withSize: textSizeTopicType
        )
        
        mLabelTopicType.text = collection?
            .title?
            .uppercased()
        
        mLabelTopicType.sizeToFit()
        mLabelTopicType.centerH(
            in: view
        )
    }
    
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
        
        mViewPlayer = playerView
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
        
        var rand: UInt16 = 0
        while true {
            rand = collection?.topicIds
                .randomElement() ?? 0
            if rand == 0 || rand != topicId {
                break
            }
        }
        
        mPlayer?.pause()
        mPlayer = nil
        loadingState()
        mPrevTopicIds.append(topicId)
        topicId = rand
        mServicePreview.getTopicPreview(
            id: topicId,
            type: collection?.cardType ?? .M
        )
    }
    
    private func onClickBtnBack() {
        if mPrevTopicIds.isEmpty {
            return
        }
        mPlayer?.pause()
        mPlayer = nil
        loadingState()
        topicId = mPrevTopicIds.removeLast()
        mServicePreview.getTopicPreview(
            id: topicId,
            type: collection?.cardType ?? .M
        )
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
        forEachView { it in
            it.isUserInteractionEnabled = false
        }
        
        mServicePreview.cancel()
        mServiceContent.cancelTask()
        
        mPlayer?.pause()
        mPlayer = nil
        popBaseAnim()
    }
    
    private func loadingState() {
        forEachView { it in
            it.isUserInteractionEnabled = false
        }
        
        mSlider.progress = 0
        mSlider.setNeedsDisplay()
        
        mViewPlayer?.isPlaying = false
        
        mLabelFinishTime.text = "--:--"
        mLabelCurrentTime.text = "00:00"
        
        mLabelTopicName.text = .locale(
            "loading"
        )
        mLabelTopicName.sizeToFit()
        mLabelTopicName.centerH(
            in: view
        )
    }
    
}

extension SKViewControllerTopic {
    
    private func onChangePlayerStatus(
        _ playerItem: AVPlayerItem
    ) {
        if playerItem.status == .readyToPlay {
            mLabelFinishTime.text = playerItem
                .duration
                .seconds
                .toTimeString()
            
            mLabelFinishTime.sizeToFit()
            
            calculateLabelName()
            calculateLabelType()
        }
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
        
        
        mPlayer = SKPlayerAudio(
            playerItem: item
        )
        
        do {
            if let it = mPlayer {
                try it.prepareSession()
                it.onTickPlayer = self
                
                observerPlayerStatus = item.observe(
                    \.status,
                    options: [.new, .old]
                ) { [weak self] playerItem, change in
                    self?.onChangePlayerStatus(
                        playerItem
                    )
                }
            }
        } catch {
            Log.d(
                SKViewControllerTopic.self,
                "onGetContentUrl: ERROR:",
                error
            )
        }
        
        forEachView { it in
            it.isUserInteractionEnabled = true
        }
    }
    
}

extension SKViewControllerTopic
: SKIListenerOnTickAudio {
    
    func onTickAudio(
        player: SKPlayerAudio
    ) {
        guard let item = player.currentItem else {
            return
        }
        mSlider.progress = CGFloat(player.currentTime().seconds / item.duration.seconds
        )
        mSlider.setNeedsDisplay()
        
        mLabelCurrentTime.text = player
            .currentTime()
            .seconds
            .toTimeString()
    }
    
}

extension SKViewControllerTopic
: SKDelegateOnGetTopicPreview {
    
    func onGetTopicPreview(
        preview: SKModelTopicPreview
    ) {
        topicName = preview.title
        if preview.isPremium && !SKViewControllerMain.mIsPremiumUser {
            mPrevTopicIds.removeLast()
            onClickBtnNext()
            return
        }
        
        mServiceContent.getContentUrlAsync(
            id: topicId
        )
    }
    
}

extension SKViewControllerTopic
: SKIListenerOnChangeProgress {
    
    func onChangeProgress(
        progress: CGFloat
    ) {
        guard let player = mPlayer,
            let item = player.currentItem else {
            return
        }
        
        player.seek(
            to: CMTime(
                seconds: Double(progress) * item.duration.seconds,
                preferredTimescale: 60000
            ),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }
    
}

extension SKViewControllerTopic
: SKIListenerOnFailDownload {
    
    func onFailDownload(
        error: (any Error)?
    ) {
        forEachView { it in
            it.isUserInteractionEnabled = true
        }
    }
    
}
