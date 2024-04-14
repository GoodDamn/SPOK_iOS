//
//  BaseTopicController.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import AVFoundation
import UIKit

final class BaseTopicController
    : StackViewController {
    
    private let TAG = "BaseTopicController"
    
    private var mScriptReader: ScriptReader? = nil
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private var mId = Int.min
    private var mNetworkUrl = ""
    private var mIsFirstTouch = true
    
    private var mCacheFile: CacheProgress<Void>!
    private let mEngine =
        SPOKContentEngine()
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mLabelSong: UILabela? = nil
    
    private var mBtnClose: UIImageButton!
    
    private var mProgressBar: ProgressBar!
    private var mProgressBarTopic: ProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Log.d(
            TAG,
            "viewDidLoad()"
        )
        
        let w = view.width()
        let h = view.height()
        
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
        
        mBtnClose.onClick = onClickBtnClose(_:)
        
        view.addSubview(
            mBtnClose
        )
        
        view.addSubview(
            mProgressBarTopic
        )
        
        let mFont = UIFont
            .extrabold( // 0.057
                withSize: w * 0.047
            )
        
        let mTextColor = UIColor(
            named: "text_topic"
        )
        
        view.backgroundColor = .background()
                
        let mHideOffsetY = h * 0.3
        
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
                    x: w * 0.1,
                    y: 0,
                    width: w * 0.9,
                    height: 0),
                scriptText.spannableString
            )

            textView.font = mFont
            textView.textColor = mTextColor
            
            textView.attribute()
            textView.sizeToFit()
            
            textView.frame.origin.y = s
                .view.center.y -
                textView.height() -
                textView.font.pointSize
            
            textView.frame.origin.x = (s
                .view.width() - textView.width()
            ) * 0.5
            
            textView.show(
                duration: 0.7
            )

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
                .hide(
                    duration: 1.0,
                    mHideOffsetY
                )
            
            s.mPrevTextView = textView
        }
        
    }
    
    private func onClickBtnClose(
        _ sender: UIView
    ) {
        mCurrentPlayer?
            .stopFade(
                duration: 0.39
            )
        
        sender.isUserInteractionEnabled = false
        popBaseAnim()
    }
    
    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
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
}

extension BaseTopicController {
    
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
        
        Log.d(TAG, "initEngine!!!LOAD_RES")
        
        mEngine.loadResources(
            dataSKC: &data
        )
        
        Log.d(TAG, "initEngine!!!SCRIPT_READER")
        mScriptReader = ScriptReader(
            engine: mEngine,
            dataSKC: &data
        )
        
        DispatchQueue.ui {
            [weak self] in
            self?.startTopic()
        }
    }
    
    private func startTopic() {
        guard let r = mScriptReader else {
            return
        }
        
        mProgressBarTopic
            .alpha(
                duration: 0.3,
                1.0
            )
        
        r.setOnReadScriptListener(
            self
        )
        
        r.next()
        showLabelSong()
    }
    
    private func showLabelSong() {
        
        guard let meta = mEngine
            .metadataAmbient() else {
            return
        }
        
        let w = view.width()
        let h = view.height()
        
        let mLeft = w * 0.1
        
        mLabelSong = UILabela(
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
            withSize: w * 0.055
        )
        label.textColor = .white
        label.text = "\(meta.artist) - \(meta.title)"
        
        label.leftImage = UIImage(
            systemName: "music.note"
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        label.leftImageColor = .white
        label.attribute()
        label.sizeToFit()
        
        label.frame
            .origin
            .x = (w - label.frame.width) * 0.5
        
        label.alpha = 0
        
        view.addSubview(
            label
        )
        
        label.alpha(
            0.65
        )
    }
    
    private func nothing() {
        Toast.init(
            text: "Nothing found",
            duration: 1.8
        ).show()
        
        pop(
            duration: 0.3
        ) { [weak self] in
            self?.view.alpha = 0
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
    
    func onWrittenStorage() {}
    
    func onProgress(percent: Double) {
        mProgressBar.mProgress = percent
    }
    
    func onSuccess() {
        mProgressBar.alpha(
            duration: 1.2,
            0.0
        ) { [weak self] _ in
            self?.mProgressBar.removeFromSuperview()
        }
        
        DispatchQueue.global(
            qos: .default
        ).async { [weak self] in
            
            guard let s = self else {
                Log.d(
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
        view.isUserInteractionEnabled = false
        mBtnClose.isUserInteractionEnabled = false
        
        mCurrentPlayer?.stopFade(
            duration: 2.4
        )
        
        if mPrevTextView == nil {
            pop(
                duration: 0.2
            ) { [weak self] in
                self?.view.alpha = 0
            }
            return
        }
        
        mPrevTextView?.animate(
            duration: 2.5,
            animations: { [weak self] in
                self?.mPrevTextView!.alpha = 0.0
            }
        ) { [weak self] _ in
            self?.pop(
                duration: 0.2
            ) {
                self?.view.alpha = 0
            }
        }
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
            Log.d(TAG, "onAmbient: ERROR::SESSION",error)
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
        Log.d(TAG, "onError:",errorMsg)
    }
}
