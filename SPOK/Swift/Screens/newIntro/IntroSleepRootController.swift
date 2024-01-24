//
//  IntroSleepRootController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit
import AVFoundation

class IntroSleepRootController
    : StackViewController {
    
    private final let TAG = "IntroSleepRootController"
    
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
        
        let intro1 = IntroSleepViewController()
        let intro2 = IntroSleep2ViewController()
        let intro3 = IntroSleep3ViewController()
        
        intro3.onWillHide = {
            UserDefaults()
                .setValue(
                    true,
                    forKey: "intro");
            
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
        
        addChild(intro1)
        view.addSubview(intro1.view)
        
        intro1.onEndTimer = {
            intro1.hide()
        }
        
        intro1.onHide = {
            intro1.view.removeFromSuperview()
            intro1.removeFromParent()
            
            let s = self
            
            s.addChild(intro2)
            s.view.addSubview(intro2.view)
            
            intro2.onHide = {
                intro2.view.removeFromSuperview()
                intro2.removeFromParent()
                
                s.addChild(intro3)
                s.view.addSubview(intro3.view)
                
                intro3.show()
            }
            
            intro2.show() {
                audio?.play()
                audio?.setVolume(
                    1.0,
                    fadeDuration: 2.0
                )
                intro2.startTopic()
            }
        }
        
        intro1.show()
        intro1.startTimer(
            duration: 3.0
        )
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
