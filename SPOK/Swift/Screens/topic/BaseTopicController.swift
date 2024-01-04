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
            
            print(self.TAG, "END_SCRIPT:", scriptText.spannableString)
            
            let v = self.view
            
            let f = v!.frame
            
            let textView = UITextViewPhrase(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: f.width,
                    height: f.height)
            )
            
            textView.initial(
                t: scriptText.spannableString
            )
            
            textView.show()

            v!.insertSubview(
                textView,
                at: 0)
            
            self.mPrevTextView?.hide(350)
            
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
        _ player: AVAudioPlayer
    ) {
        
    }
    
    func onSFX(
        _ sfxId: Int,
        _ soundPool: [AVAudioPlayer]
    ) {
        
    }
    
    func onError(
        _ errorMsg: String
    ) {
        
    }
    
    func onFinish() {
        
    }
    
}
