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
        
        Storage
            .storage()
            .reference(
                withPath: path
            ).getData(
                maxSize: 10*1024*1024
            ) { data, error in
                
                if data == nil || error != nil {
                    print(self.TAG, "ERROR:DATA:",error)
                    self.nothing()
                    return
                }
                
                var data = data
                
                if data!.count == 0 {
                    self.nothing()
                    return
                }
                
                StorageApp.content(
                    id: self.mId,
                    data: &data
                )
                completion(data!)
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
