//
//  BaseTopicController.swift
//  SPOK
//
//  Created by GoodDamn on 03/01/2024.
//

import Foundation
import AVFoundation
import UIKit

class BaseTopicController
    : UIViewController,
      OnReadCommand,
      OnReadScript {
    
    private final let TAG = "BaseTopicController:"
    
    private var mScriptReader: ScriptReader? = nil
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private let mEngine =
        SPOKContentEngine()
    
    @objc func onTouch(
        _ sender: UIButton
    ) {
        mScriptReader!.next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(
            named: "background")
        
        let viewFrame = view.frame
        
        let mSpanPointX = viewFrame.width * 0.1
        let mSpanPointY = viewFrame.height * 0.4
        
        let mHideOffsetY = viewFrame.height * 0.3
        
        let fm = FileManager.default
        
        let url = fm
            .urls(
                for: .cachesDirectory,
                in: .userDomainMask)[0]
        
        let urlSkc = url
            .appendingPathComponent(
                "14.skc"
            )
        
        print(TAG, "PATH_SKC:",urlSkc)
        
        guard let data = fm.contents(
            atPath: urlSkc.path
        ) else {
            print(TAG, "INVALID_PATH_SKC")
            return
        }
        
        mEngine.loadResources(
            dataSKC: [UInt8](data))
        
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
        
        mScriptReader = ScriptReader(
            engine: mEngine,
            dataSKC: [UInt8](data)
        )
        
        mScriptReader!.setOnReadScriptListener(
            self
        )
        
        let btnNext = UIButton(frame: view.frame)
        btnNext.addTarget(
            self,
            action: #selector(onTouch(_:)),
            for: .touchUpInside)
        
        view.addSubview(btnNext)
        
        mScriptReader!.next()
    }
    
    func onAmbient(
        _ player: AVAudioPlayer?
    ) {
        print(TAG, "onAmbient", player)
        player?.play()
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
        
    }
    
}
