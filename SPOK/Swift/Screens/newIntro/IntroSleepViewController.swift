//
//  IntroSleepViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleepViewController
    : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let sizeTitle = w * 0.086
        let sizeSubtitle = w * 0.04
        
        let extraBold = UIFont(
            name: "OpenSans-ExtraBold",
            size: sizeTitle
        )
        
        let lTitle = UILabel(
            frame: CGRect(
                x: w*0.1,
                y: h*0.05,
                width: w,
                height: sizeTitle * 6
            )
        )
        
        let lSubtitle = UILabel(
            frame: CGRect(
                x: 0,
                y: h * 0.786,
                width: w,
                height: sizeSubtitle * 3
            )
        )
        
        lTitle.text = "Добро\nпожаловать в\nSPOK.Сон"
        lTitle.font = extraBold
        lTitle.textColor = .white
        lTitle.numberOfLines = 0
        
        lSubtitle.text = "готовим что-то\n уникальное..."
        lSubtitle.font = extraBold?
            .withSize(sizeSubtitle)
        lSubtitle.textColor = .white
        lSubtitle.textAlignment = .center
        lSubtitle.numberOfLines = 0
        
        view.addSubview(lTitle)
        view.addSubview(lSubtitle)
        
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + 2.0
            ) {
                self.moveToNextController()
            }
    }
 
    private func moveToNextController() {
        
        let intro2 = IntroSleep2ViewController()
        
        let window = UIApplication
            .shared
            .windows[0]
        
        UIView.transition(
            from: view,
            to: intro2.view,
            duration: 2.0,
            options: [.curveEaseIn]
        ) { b in
            window.rootViewController = intro2
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
}
