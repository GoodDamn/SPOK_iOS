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
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private var mProgressBar: ProgressBar!
    
    private var mId = Int.min
    
    private var mNetworkUrl = ""
    
    private let mEngine =
        SPOKContentEngine()
    
    @objc func onTouch(
        _ sender: UITapGestureRecognizer
    ) {
        mScriptReader!.next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        modalPresentationStyle = .overFullScreen
        
        let mFont = UIFont(
            name: "OpenSans-SemiBold",
            size: view.frame.width * 0.057
        )
        
        let mTextColor = UIColor(
            named: "text_topic"
        )
        
        let gestureTap = UITapGestureRecognizer(
            target: self,
            action: #selector(
                onTouch(_:)
            )
        )
        
        gestureTap.numberOfTapsRequired = 1
        
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(
            gestureTap
        )
        
        view.backgroundColor = UIColor(
            named: "background")
        
        let viewFrame = view.frame
        
        let mSpanPointX = viewFrame.width * 0.1
        let mSpanPointY = viewFrame.height * 0.4
        
        let mHideOffsetY = viewFrame.height * 0.3
        
        initEngine()
        
        mEngine.setOnReadCommandListener(
            self
        )
        
        mEngine.setOnEndScriptListener {
            scriptText in
            
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

            self.view
                .insertSubview(
                    textView,
                    at: 0)
            
            self.mPrevTextView?
                .hide(mHideOffsetY)
            
            self.mPrevTextView = textView
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
                .setCategory(.playback)
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
        
        let f = 1.5
        
        prevP.setVolume(
            0.0,
            fadeDuration: f)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + f
        ) {
            prevP.stop()
            self.mCurrentPlayer = player
        }
    }
    
    func onSFX(
        _ sfxId: Int?,
        _ soundPool: [AVAudioPlayer?]
    ) {
        print(TAG, "onSFX")
    }
    
    func onError(
        _ errorMsg: String
    ) {
        print(TAG, "onError:",errorMsg)
    }
    
    func onFinish() {
        
        view.gestureRecognizers?[0].isEnabled = false
        view.isUserInteractionEnabled = false
        
        if let player = mCurrentPlayer {
            let dur = 2.5
            player.setVolume(
                0.0,
                fadeDuration: dur
            )
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + dur
            ) {
                player.stop()
            }
        }
        
        
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
    
    private func initEngine() {
        downloadSKC(
            path: mNetworkUrl
        ) { data in
            
            DispatchQueue.global(
                qos: .default
            ).async { [weak self] in
                
                guard let s = self else {
                    print("BaseTopicController:downloadSKC:GC")
                    return
                }
                
                let TAG = s.TAG
                let engine = s.mEngine
                
                var data = data
                
                engine.loadResources(
                    dataSKC: &data
                )
                
                s.mScriptReader = ScriptReader(
                    engine: engine,
                    dataSKC: &data
                )
                
                DispatchQueue.main.async {
                    guard let r = s.mScriptReader else {
                        return
                    }
                    
                    r.setOnReadScriptListener(
                        s
                    )
                    
                    r.next()
                    
                    s.view.isUserInteractionEnabled = true
                }
                
            }
        }
    }
    
    private func downloadSKC(
        path: String,
        completion: @escaping (Data)->Void
    ) {
        
        let d = StorageApp
            .content(id: mId)
        
        if d != nil {
            completion(d!)
            return
        }
        
        let ref = Storage
            .storage()
            .reference(
                withPath: path
            )
        
        let w = view.frame.width
        let h = view.frame.height
        
        mProgressBar = ProgressBar(
            frame: CGRect(
                x: w * 0.35,
                y: h * 0.8,
                width: w * 0.3,
                height: h * 0.03
            )
        )
        
        mProgressBar.mColorBack = .white
            .withAlphaComponent(0.2)
        
        mProgressBar.mColorProgress = .white
        mProgressBar.maxProgress = 100
        mProgressBar.mProgress = 0
        
        view.addSubview(mProgressBar)
        
        let downloadTask = ref.write(
            toFile: StorageApp
                .contentUrl(
                    id: mId
                )
        ) { [weak self] url, error in

            guard let url = url, error == nil else {
                print(
                    "BaseTopicController:URL_DOWNLOAD_ERROR::",
                    error
                )
                return
            }
            
            guard let s = self else {
                return
            }
            
            print("BaseTopicController: DOWNLOAD COMPLETED!",url)
            
            UIView.animate(
                withDuration: 1.2,
                animations: {
                    s.mProgressBar
                        .alpha = 0
                }
            ) { _ in
                s.mProgressBar.removeFromSuperview()
            }
            
            guard let data = StorageApp
                .content(
                    id: s.mId
                ) else {
                return
            }
            
            completion(data)
            
        }
        
        downloadTask.observe(
            .progress
        ) { [weak self] snapshot in
            
            guard let s = self else {
                return
            }
            
            guard let progress = snapshot
                .progress else {
                return
            }
            
            let prog = 100 * Double(progress
                .completedUnitCount
            ) / Double(progress.totalUnitCount)
            
            s.mProgressBar.mProgress = prog
        }
        
        downloadTask.observe(
            .failure
        ) { [weak self] snap in

            guard let s = self else {
                print("BaseTopicController: FAIL: GC")
                return
            }
            
            print(s.TAG, "FAIL:",snap.error)
            
            s.nothing()
        }
        
        downloadTask.observe(
            .success
        ) { [weak self] snap in
            
            guard let s = self else {
                print(
                    "BaseTopicController:SUCCESS: GC"
                )
                return
            }
            
            print(s.TAG, "SUCCESS DOWNLOAD!")
            
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
