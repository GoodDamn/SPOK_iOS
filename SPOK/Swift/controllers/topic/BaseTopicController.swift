//
//  BaseTopicController.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import AVFoundation
import UIKit
import FirebaseStorage

class BaseTopicController
    : StackViewController {
    
    private final let TAG = "BaseTopicController:"
    
    private var mScriptReader: ScriptReader? = nil
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mLabelSong: ImageLabel? = nil
    
    private var mBtnClose: UIButton!
    
    private var mProgressBar: ProgressBar!
    private var mProgressBarTopic: ProgressBar!
    
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private var mId = Int.min
    private var mNetworkUrl = ""
    private var mIsFirstTouch = true
    
    private var mCacheFile: CacheProgress<Void>!
    private let mEngine =
        SPOKContentEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(TAG, "viewDidLoad()")
        
        modalPresentationStyle = .overFullScreen
        
        mProgressBarTopic = ViewUtils
            .progressBar(
                frame: view.frame,
                x: 0.284,
                y: 0.925,
                width: 0.432,
                height: 0.004
            )
        
        mProgressBarTopic.alpha = 0
        
        mBtnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.136
            )
        
        mBtnClose.alpha = 0.11
        
        mBtnClose.addTarget(
            self,
            action: #selector(
                onClickBtnClose(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(
            mBtnClose
        )
        
        view.addSubview(
            mProgressBarTopic
        )
        
        let mFont = UIFont(
            name: "OpenSans-SemiBold",
            size: view.frame.width * 0.047 // 0.057
        )
        
        let mTextColor = UIColor(
            named: "text_topic"
        )
        
        view.isUserInteractionEnabled = false
        
        view.backgroundColor = UIColor(
            named: "background")
        
        let viewFrame = view.frame
        
        let mSpanPointX = viewFrame.width * 0.1
        let mSpanPointY = viewFrame.height * 0.4
        
        let mHideOffsetY = viewFrame.height * 0.3
        
        mCacheFile = CacheProgress<Void>(
            pathStorage: mNetworkUrl,
            localPath: StorageApp
                .contentUrl(
                    id: mId
                ),
            backgroundLoad: true
        )
        
        mCacheFile.delegate = self
        
        mCacheFile.load()
        
        mEngine.setOnReadCommandListener(
            self
        )
        
        mEngine.setOnEndScriptListener {
            [weak self] scriptText in
            
            guard let s = self else {
                return
            }
            
            let textView = UITextViewPhrase(
                frame: CGRect(
                    x: mSpanPointX,
                    y: mSpanPointY,
                    width: viewFrame.width - mSpanPointX*2,
                    height: 0),
                scriptText.spannableString
            )

            textView.font = mFont
            textView.textColor = mTextColor
            textView.show()

            let prog = s.mScriptReader?
                .progress() ?? 0
            
            s.mProgressBarTopic
                .mProgress = s
                    .mProgressBarTopic
                    .maxProgress * prog
            
            s.view.insertSubview(
                textView,
                at: 0
            )
            
            s.mPrevTextView?
                .hide(mHideOffsetY)
            
            s.mPrevTextView = textView
        }
        
    }
    
    public func setID(
        _ id: Int
    ) {
        mId = id
        mNetworkUrl = "content/skc/\(id).skc"
    }
    
    @objc func onTouch(
        _ sender: UITapGestureRecognizer
    ) {
        if mIsFirstTouch {
            mIsFirstTouch = false
            mLabelSong?.alpha(
                0.0
            ) { [weak self] _ in
                self?.mLabelSong?.removeFromSuperview()
            }
        }
        
        mScriptReader!.next()
    }
    
    @objc override func onClickBtnClose(
        _ sender: UIButton
    ) {
        sender.isEnabled = false

        mCurrentPlayer?
            .stopFade(
                duration: 0.39
            )
        
        pop(
            duration: 0.4
        ) {
            self.view.alpha = 0
        }
    }
    
}

extension BaseTopicController {
    
    // Better to load on background thread
    private func initEngine(
        _ data: inout Data?
    ) {
        guard var data = data else {
            return
        }
        
        print(TAG, "initEngine!!!LOAD_RES")
        
        mEngine.loadResources(
            dataSKC: &data
        )
        
        print(TAG, "initEngine!!!SCRIPT_READER")
        mScriptReader = ScriptReader(
            engine: mEngine,
            dataSKC: &data
        )
        
        DispatchQueue.main.async {
            [weak self] in
            self?.startTopic()
        }
    }
    
    private func startTopic() {
        guard let r = mScriptReader else {
            return
        }

        view
            .gestureRecognizers?
            .removeAll()
        
        let g = UITapGestureRecognizer(
            target: self,
            action: #selector(
                onTouch(_:)
            )
        )
        
        g.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(
            g
        )
        
        UIView.animate(
            withDuration: 0.3
        ) { [weak self] in
            self?.mProgressBarTopic.alpha = 1.0
        }
        
        r.setOnReadScriptListener(
            self
        )
        
        r.next()
        
        view.isUserInteractionEnabled = true
        
        showLabelSong()
    }
    
    private func showLabelSong() {
        
        guard let meta = mEngine
            .metadataAmbient() else {
            return
        }
        
        let w = view.frame.width
        let h = view.frame.height
        
        let mLeft = w * 0.1
        
        mLabelSong = ImageLabel(
            frame: CGRect(
                x: mLeft,
                y: h * 0.8,
                width: w - mLeft*2,
                height: 1
            )
        )
        
        guard let label = mLabelSong
            else {
            return
        }
        
        label.textColor = .white
        label.font = .semibold(
            withSize: h * 0.025
        )
        label.textColor = .white
        label.text = "\(meta.artist) - \(meta.title)"
        
        label.image = UIImage(
            systemName: "music.note"
        )
        
        label.imageColor = .white
        label.sizeToFit()
        
        label
            .frame
            .origin
            .x = (w - label.frame.width) * 0.5
        
        label.alpha = 0
        
        view.addSubview(
            label
        )
        
        label.alpha(
            1.0
        )
        
    }
    
    private func nothing() {
        Toast.init(
            text: "Nothing found",
            duration: 1.8
        ).show()
        
        pop(
            duration: 0.3
        ) {
            self.view.alpha = 0
        }
        
    }
}

extension BaseTopicController
    : CacheProgressListener {
    
    func onPrepareDownload() {
        
        mProgressBar = ViewUtils
            .progressBar(
                frame: view.frame
            )
        
        view.addSubview(
            mProgressBar
        )
        
    }
    
    func onWrittenStorage() {
        UIView.animate(
            withDuration: 1.2,
            animations: { [weak self] in
                self?.mProgressBar
                    .alpha = 0
            }
        ) { [weak self] _ in
            self?.mProgressBar.removeFromSuperview()
        }
        
        DispatchQueue.global(
            qos: .default
        ).async { [weak self] in
            
            guard let s = self else {
                print(
                    "BaseTopicController:",
                    "onWrittenStorage: GC"
                )
                return
            }
            
            var data = StorageApp
                .content(
                    id: s.mId
                )
            
            s.initEngine(
                &data
            )
        }
    }
    
    func onProgress(percent: Double) {
        mProgressBar.mProgress = percent
    }
    
    func onSuccess() {}
    
    func onError() {
        nothing()
    }
    
    // Background thread
    func onFile(
        data: inout Data?
    ) {
        initEngine(
            &data
        )
    }
    
    // Background thread
    func onNet(data: inout Data?) {}
    
}

extension BaseTopicController
    : OnReadScript {
    
    func onFinish() {
        view.gestureRecognizers?[0]
            .isEnabled = false
        mBtnClose.isEnabled = false
        
        mCurrentPlayer?.stopFade(
            duration: 2.4
        )
        
        if mPrevTextView == nil {
            self.pop(
                duration: 0.2
            ) {
                self.view.alpha = 0
            }
            return
        }
        
        UIView.animate(
            withDuration: 2.5,
            animations: {
                self.mPrevTextView!.alpha = 0.0
            },
            completion: { b in
                self.pop(
                    duration: 0.2
                ) {
                    self.view.alpha = 0
                }
            }
        )
    }
    
}

extension BaseTopicController
    : OnReadCommand {
    
    func onAmbient(
        _ player: AVAudioPlayer?
    ) {
        
        Log.d(TAG, "onAmbient",player?.data)
        let ses = AVAudioSession
            .sharedInstance()
        do {
            try ses
                .setCategory(
                    .playback
                )
            try ses.setActive(true)
        } catch {
            print(TAG, "onAmbient: ERROR::SESSION",error)
        }
        player?.play()
        player?.setVolume(
            1.0,
            fadeDuration: 1.5
        )
        
        guard let prevP = mCurrentPlayer else {
            mCurrentPlayer = player
            return
        }
        
        prevP.stopFade { [weak self] in
            self?.mCurrentPlayer = prevP
        }
    }
    
    func onSFX(
        _ sfxId: Int?,
        _ soundPool: [AVAudioPlayer?]
    ) {
        Log.d(TAG, "onSFX")
        
        guard let id = sfxId else {
            return
        }
        
        if id < 0 || id >= soundPool.count {
            return
        }
        
        soundPool[id]?.play()
        
    }
    
    func onError(
        _ errorMsg: String
    ) {
        print(TAG, "onError:",errorMsg)
    }
}

extension AVAudioPlayer {
    
    func stopFade(
        duration f: TimeInterval = 1.5,
        completion: (()->Void)? = nil
    ) {
        setVolume(
            0.0,
            fadeDuration: f)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + f
        ) { [weak self] in
            self?.stop()
            completion?()
        }
    }
    
}
