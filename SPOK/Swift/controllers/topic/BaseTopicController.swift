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
    : StackViewController,
      OnReadCommand,
      OnReadScript {
    
    private final let TAG = "BaseTopicController:"
    
    private var mScriptReader: ScriptReader? = nil
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mProgressBar: ProgressBar!
    private var mProgressBarTopic: ProgressBar!
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private var mId = Int.min
    private var mNetworkUrl = ""
    
    private var mCacheFile: CacheProgress<Void>!
    private let mEngine =
        SPOKContentEngine()
    
    private var mBtnClose: UIButton!
    
    @objc func onTouch(
        _ sender: UITapGestureRecognizer
    ) {
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
    
    func onAmbient(
        _ player: AVAudioPlayer?
    ) {
        
        print(TAG, "onAmbient",player?.data)
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
        print(TAG, "onSFX")
        
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
    
    public func setID(
        _ id: Int
    ) {
        mId = id
        mNetworkUrl = "content/skc/\(id).skc"
    }
    
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
            
            guard let s = self else {
                print(
                    "BaseTopicController:",
                    "initEngine: GC"
                )
                return
            }
            
            guard let r = s.mScriptReader else {
                return
            }
            
            print(s.TAG, "initEngine!!!GESTURES")
            
            s.view
                .gestureRecognizers?
                .removeAll()
            
            let g = UITapGestureRecognizer(
                target: self,
                action: #selector(
                    s.onTouch(_:)
                )
            )
            
            g.numberOfTapsRequired = 1
            
            s.view.addGestureRecognizer(
                g
            )
            
            UIView.animate(
                withDuration: 0.3
            ) {
                s.mProgressBarTopic.alpha = 1.0
            }
            
            r.setOnReadScriptListener(
                self
            )
            
            r.next()
            
            s.view.isUserInteractionEnabled = true
        }
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
        let w = view.frame.width
        let h = view.frame.height
        
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
