//
//  IntroSleepRootController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit
import AVFoundation

final class IntroSleepRootController
    : StackViewController {
    
    private final var mStart: (() -> Void)?
    
    override func onTransitionEnd() {
        mStart?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        modalPresentationStyle = .overFullScreen
        
        var audio: AVAudioPlayer?
        
        if let url = Bundle.main.url(
            forResource: "sheep_m",
            withExtension: ".mp3"
        ) {
            audio = try? AVAudioPlayer(
                contentsOf: url,
                fileTypeHint: AVFileType.mp3
                    .rawValue
            )
            audio?.numberOfLoops = -1
            audio?.prepareToPlay()
            audio?.setVolume(
                0.0,
                fadeDuration: 0
            )
            let i = AVAudioSession
                .sharedInstance()
            try? i.setCategory(.playback)
            try? i.setActive(true)
            
        }
        
        let bgColor = UIColor(
            named: "background"
        )
        
        view.backgroundColor = bgColor
        
        let mIntro2 = IntroSleep2ViewController()
        let intro3 = IntroSleep3ViewController()
        
        intro3.onWillHide = {
            UserDefaults
                .standard
                .setValue(
                    true,
                    forKey: Keys.COMPLETE_INTRO
                )
            
            audio?.setVolume(
                0.0,
                fadeDuration: 2.0
            )
        }
        
        intro3.onHide = {
            
            let window = UIApplication
                .shared
                .windows[0]
            
            let mainNav = MainContentViewController()
            
            self.pusht(
                mainNav,
                animDuration: 2.0,
                options: [
                    .transitionCrossDissolve
                ]
            ) { _ in
                audio?.stop()
                // previous view controller
                self.pop(
                    at: 0
                )
            }
        }
        
        mIntro2.onHide = { [weak self] in
            
            guard let s = self else {
                return
            }
            
            mIntro2.view.removeFromSuperview()
            mIntro2.removeFromParent()
            
            s.addChild(intro3)
            s.view.addSubview(intro3.view)
            
            intro3.show()
            
        }
        
        addChild(mIntro2)
        view.addSubview(mIntro2.view)
    
        ViewUtils.debugLines(
            in: intro3.view
        )
        
        mStart = {
            mIntro2.show() {
                audio?.play()
                audio?.setVolume(
                    1.0,
                    fadeDuration: 2.0
                )
                mIntro2.startTopic()
            }
        }
        
        
        ViewUtils.debugLines(
            in: view
        )
        
    }

}
