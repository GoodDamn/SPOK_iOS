//
//  IntroSleep2ViewController.swift
//  SPOK
//
//  Created by GoodDamn on 09/01/2024.
//

import Foundation
import UIKit

final class IntroSleep2ViewController
    : DelegateViewController {
    
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
    
    private var mProgressBar: ProgressBar!
    private var mCurrent = 0
    private var mFont: UIFont? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = true
        
        Log.d(
            IntroSleep2ViewController.self,
            "DID LOAD"
        )
        
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
        
        let wpb = w * 0.234
        
        mProgressBar = ProgressBar(
            frame: CGRect(
                x: (w - wpb) / 2,
                y: h*0.886,
                width: wpb,
                height: h * 0.016
            )
        )
        
        mProgressBar.mColorBack = UIColor(
            red: 1.0,
            green: 1.0,
            blue: 1.0,
            alpha: 0.2
        )
        
        mProgressBar.mColorProgress = .white
        
        mProgressBar.maxProgress = CGFloat(mPieces.count)
        
        mProgressBar.mProgress = 0
        
        view.addSubview(mProgressBar)
        
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(next(_:))
        )
        
        gesture.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(
            gesture
        )
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension IntroSleep2ViewController {
    
    @objc private func next(
        _ sender: UITapGestureRecognizer
    ) {
        nextPiece()
    }
    
    final func startTopic() {
        nextPiece()
    }
    
    private final func nextPiece() {
        Log.d(
            IntroSleep2ViewController.self,
            "onNext:",
            mCurrent,
            mPieces.count
        )
        
        mProgressBar.mProgress = CGFloat(mCurrent)
        
        if mCurrent >= mPieces.count {
            view.isUserInteractionEnabled = false
            // Move to another controller
            self.hide()
            mPrevTextView?.hide(300)
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
            ), mPieces[mCurrent]
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
    
}
