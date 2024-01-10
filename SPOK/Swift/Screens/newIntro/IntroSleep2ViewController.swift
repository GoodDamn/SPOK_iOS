//
//  IntroSleep2ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

class IntroSleep2ViewController
    : DelegateViewController {
    
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
    }
    
    @objc func next(
        _ sender: UITapGestureRecognizer
    ) {
        nextPiece()
    }
    
    func startTopic() {
        nextPiece()
    }
    
    private func nextPiece() {
        print(TAG, "onNext:", mCurrent, mPieces.count)
        
        if mCurrent >= mPieces.count {
            view.isUserInteractionEnabled = false
            // Move to another controller
            
            mPrevTextView?.hide(300) {
                
                self.onHide?()
            }
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
