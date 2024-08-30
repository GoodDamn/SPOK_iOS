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
    
    private var mNetworkUrl = ""
    private var mIsFirstTouch = true
    
    private var mIsGotContent = false
    
    private let mServiceContent = SKServiceTopicContent()
    private let mEngine = SPOKContentEngine()
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mLabelSong: UILabela? = nil
    
    private var mBtnClose: UIImageButton? = nil
    
    private var mProgressBar: ProgressBar? = nil
    private var mProgressBarTopic: ProgressBar? = nil
    
    private var mIsTopicFinished = false
    
    var topicId = Int.min {
        didSet {
            mNetworkUrl = "content/skc/\(topicId).skc"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Log.d(
            TAG,
            "viewDidLoad()"
        )
        
        getStatRefId(
            "\(topicId)/LOAD_"
        ).increment()
        
        let w = view.width()
        let h = view.height()
        
        modalPresentationStyle = .overFullScreen
        
        mBtnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.136
            )
        
        if let it = mBtnClose {
            it.alpha = 0.11
            it.onClick = { [weak self] view in
                self?.onClickBtnClose(
                    view
                )
            }
            view.addSubview(it)
        }
        
        mProgressBarTopic = ViewUtils
            .progressBar(
                frame: view.frame,
                x: 0.284,
                y: 0.925,
                width: 0.432,
                height: 0.004
            )
        
        if let it = mProgressBarTopic {
            it.alpha = 0
            view.addSubview(it)
        }
        
        let mFont = UIFont
            .extrabold( // 0.057
                withSize: w * 0.047
            )
        
        let mTextColor = UIColor(
            named: "text_topic"
        )
        
        view.backgroundColor = .background()
                
        let mHideOffsetY = h * 0.3
        
        mServiceContent.delegate = self
        mServiceContent.delegateProgress = self
        
        mEngine.onReadCommand = self
        mEngine.onEndScript = {
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
            
            s.mProgressBarTopic?
                .mProgress = (s
                    .mProgressBarTopic?
                    .maxProgress ?? 0) * prog
            
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
        
        mProgressBar = ViewUtils.progressBar(
            frame: view.frame
        )
        
        if let it = mProgressBar {
            view.addSubview(it)
        }
        
        mServiceContent.getContent(
            id: topicId
        )
    }
    
    deinit {
        mServiceContent.cancelTask()
    }
    
    private func onClickBtnClose(
        _ sender: UIView
    ) {
        mCurrentPlayer?.stopFade(
            duration: 0.39
        )
        
        sender.isUserInteractionEnabled = false
        
        getStatRefId(
            "\(topicId)/CLOSE_"
        ).increment()
        
        timeIncrement(
            "\(topicId)/CLOSE_TIME_"
        )
        
        popBaseAnim()
    }
    
    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        if mIsTopicFinished {
            return
        }
        
        if mIsFirstTouch {
            mIsFirstTouch = false
            mLabelSong?.alpha(
                0.0
            ) { [weak self] _ in
                self?.mLabelSong?.removeFromSuperview()
            }
        }
        
        mScriptReader?.next()
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
        
        if data.isEmpty {
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
        
        DispatchQueue.ui { [weak self] in
            self?.startTopic()
        }
    }
    
    private func startTopic() {
        guard let r = mScriptReader else {
            return
        }
        
        mProgressBarTopic?.alpha(
            duration: 0.3,
            1.0
        )
        
        r.onReadScript = self
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
        Toast.show(
            text: "Nothing found"
        )
        
        pop(
            duration: 0.3
        ) { [weak self] in
            self?.view.alpha = 0
        }
        
    }
}

extension BaseTopicController
: SKDelegateOnProgressDownload {
    func onProgressDownload(
        progress: CGFloat
    ) {
        mProgressBar?.mProgress = 100 * progress
    }
}

extension BaseTopicController
: SKDelegateOnGetTopicContent {
    func onGetTopicContent(
        model: SKModelTopicContent
    ) {
        if mIsGotContent {
            return
        }
        
        mIsGotContent = true
        
        mProgressBar?.alpha(
            duration: 1.2,
            0.0
        ) { [weak self] _ in
            self?.mProgressBar?
                .removeFromSuperview()
        }
        
        DispatchQueue.io { [weak self] in
            guard let s = self else {
                Log.d(
                    "BaseTopicController:",
                    "onWrittenStorage: GC"
                )
                return
            }
            
            var data = model.data
            
            s.initEngine(
                &data
            )
        }
    }
}

extension BaseTopicController
    : OnReadScript {
    
    func onFinish() {
        mIsTopicFinished = true
        mBtnClose?.isUserInteractionEnabled = false
        
        mCurrentPlayer?.stopFade(
            duration: 2.4
        )
        
        getStatRefId(
            "\(topicId)/FINISH_"
        ).increment()
        
        timeIncrement(
            "\(topicId)/FINISH_TIME_"
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
