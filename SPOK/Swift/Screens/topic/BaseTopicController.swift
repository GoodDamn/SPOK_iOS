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
    : UIViewController,
      OnReadCommand,
      OnReadScript {
    
    private final let TAG = "BaseTopicController:"
    
    private var mBtnNext: UIButton!
    
    private var mScriptReader: ScriptReader? = nil
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mCurrentPlayer: AVAudioPlayer? = nil
    
    private var mId = Int.min
    
    private var mNetworkUrl = ""
    
    private let mEngine =
        SPOKContentEngine()
    
    @objc func onTouch(
        _ sender: UIButton
    ) {
        mScriptReader!.next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        modalPresentationStyle = .overFullScreen
        
        mBtnNext = UIButton(frame: view.frame)
        mBtnNext.addTarget(
            self,
            action: #selector(onTouch(_:)),
            for: .touchUpInside)
        
        mBtnNext.isEnabled = false
        
        view.addSubview(mBtnNext)
        
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
            
            let h = viewFrame.height - mSpanPointY
            let w = viewFrame.width - 2*mSpanPointX
            
            let textView = UITextViewPhrase(
                frame: CGRect(
                    x: mSpanPointX,
                    y: mSpanPointY,
                    width: w,
                    height: h)
            )
            
            textView.initial(
                t: scriptText.spannableString
            )
            
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
        print(TAG, "onAmbient", player)
        player?.play()
        player?.setVolume(
            1.0,
            fadeDuration: 1.5
        )
        
        guard let prevP = mCurrentPlayer else {
            mCurrentPlayer = player
            return
        }
        
        prevP.setVolume(
            0.0,
            fadeDuration: 1.5)
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.5
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
        
        mBtnNext.isEnabled = false
        
        if let player = mCurrentPlayer {
            player.setVolume(
                0.0,
                fadeDuration: 2.5
            )
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.5
            ) {
                player.stop()
            }
        }
        
        
        if mPrevTextView == nil {
            navigationController?
                .popViewController(
                    animated: true
                )
            return
        }
        
        UIView.animate(
            withDuration: 3.5,
            animations: {
                self.mPrevTextView!.alpha = 0.0
            },
            completion: { b in
                self.navigationController?
                    .popViewController(
                        animated: true
                    )
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
        ) {
            DispatchQueue.global(
                qos: .background
            ).async {
                
                let TAG = self.TAG
                let engine = self.mEngine
                
                let fm = FileManager.default
                
                let urlSkc = self.getSkcPath()
                
                print(TAG, "PATH_SKC:",urlSkc)
                
                guard let data = fm.contents(
                    atPath: urlSkc
                ) else {
                    print(TAG, "INVALID_PATH_SKC")
                    return
                }
                
                engine.loadResources(
                    dataSKC: [UInt8](data))
                
                self.mScriptReader = ScriptReader(
                    engine: engine,
                    dataSKC: [UInt8](data)
                )
                
                DispatchQueue.main.async {
                    guard let r = self.mScriptReader else {
                        return
                    }
                    
                    r.setOnReadScriptListener(
                        self
                    )
                    
                    r.next()
                    
                    self.mBtnNext.isEnabled = true
                }
                
            }
        }
    }
    
    private func downloadSKC(
        path: String,
        completion: @escaping ()->Void
    ) {
        
        let fm = FileManager
            .default
        
        if fm.fileExists(
            atPath: getSkcPath()
        ) {
            completion()
            return
        }
        
        Storage
            .storage()
            .reference(
                withPath: path
            ).getData(
                maxSize: 10*1024*1024
            ) { data, error in
                guard let data = data,
                      error == nil else {
                    self.nothing()
                    return
                }
                
                if data.count == 0 {
                    self.nothing()
                    return
                }
                
                self.saveSkc(data)
                completion()
            }
    }
    
    private func getSkcPath() -> String {
        let fm = FileManager.default
        
        let cacheUrl = fm.urls(
            for: .cachesDirectory,
            in: .userDomainMask)[0]
        
        let skc = cacheUrl
            .appendingPathComponent(
                "\(mId).skc"
            )
        
        return skc.path
    }
    
    private func saveSkc(
        _ data: Data
    ) {
        FileManager
            .default
            .createFile(
                atPath: getSkcPath(),
                contents: data
        )
    }
    
    private func nothing() {
        Toast.init(
            text: "Nothing found",
            duration: 1.8
        ).show()
    }
    
    
}
