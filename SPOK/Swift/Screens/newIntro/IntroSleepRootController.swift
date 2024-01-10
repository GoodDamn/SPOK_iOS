//
//  IntroSleepRootController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleepRootController
    : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        modalPresentationStyle = .fullScreen
        
        let bgColor = UIColor(
            named: "background"
        )
        
        view.backgroundColor = bgColor
        
        let intro1 = IntroSleepViewController()
        let intro2 = IntroSleep2ViewController()
        let intro3 = IntroSleep3ViewController()
        
        addChild(intro3)
        view.addSubview(intro3.view)
        
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
                intro2.startTopic()
            }
        }
        
        intro3.show()
        intro3.onHide = {
            
            let window = UIApplication
                .shared
                .windows[0]
            
            let board = UIStoryboard(
                name: "mainNav",
                bundle: Bundle.main
            )
            
            let mainNav = board.instantiateViewController(
                withIdentifier: "manager"
            ) as! ManagerViewController
        
            window.rootViewController = mainNav
            
            UIView.transition(
                from: self.view,
                to: mainNav.view,
                duration: 2.0,
                options: [.curveLinear]
            ) { b in
                
            }
            
        }
        /*intro1.startTimer(
            duration: 3.0
        )*/
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
