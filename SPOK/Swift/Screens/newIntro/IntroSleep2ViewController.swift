//
//  IntroSleep2ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleep2ViewController
    : UIViewController {
    
    private final let TAG = "IntroSleep2ViewController"
    
    private let mPieces = [
        "привет",
        "это место, которое поможет тебе уснуть",
        "все, что ты будешь видеть здесь",
        "будет в формате такого текста",
        "приятная музыка",
        "прикосновения к экрану",
        "погружающая атмосфера",
        "все это - поможет тебе лучше уснуть",
        "давай познакомимся с форматами"
    ]
    
    private var mPrevTextView: UITextViewPhrase? = nil
    
    private var mCurrent = 0
    private var mFont: UIFont? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = true
        
        print(TAG, "DID LOAD")
        
        let w = view.frame.width
        let h = view.frame.height
        
        mFont = UIFont(
            name: "OpenSans-ExtraBold",
            size: w * 0.04
        )
        
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(next(_:))
        )
        
        gesture.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(
            gesture
        )
        
        next(gesture)
    }
    
    @objc func next(
        _ sender: UITapGestureRecognizer
    ) {
        
        print(TAG, "onNext:", mCurrent, mPieces.count)
        
        if mCurrent >= mPieces.count {
            sender.isEnabled = false
            view.isUserInteractionEnabled = false
            // Move to another controller
            
            return
        }
        
        let f = view.frame
        
        let y = f.height * 0.4
        
        let t = UITextViewPhrase(
            frame: CGRect(
                x: 0,
                y: y,
                width: f.width,
                height: f.height - y
            )
        )
        
        t.initial(
            t: mPieces[mCurrent]
        )
        
        t.font = mFont
        view.insertSubview(t, at: 0)
        
        t.show()
        
        mPrevTextView?.hide(
            300
        )
        
        mPrevTextView = t
        
        mCurrent += 1
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
