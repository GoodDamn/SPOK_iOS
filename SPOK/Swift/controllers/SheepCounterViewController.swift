//
//  SheepCounterViewController.swift
//  SPOK
//
//  Created by GoodDamn on 15/01/2024.
//

import Foundation
import UIKit
import AVFoundation

final class SheepCounterViewController
    : StackViewController {
    
    private let TAG = "SheepCounterViewController:"
    
    private var mCounter = 1
    
    private var mLabelTap: UILabel!
    private var mViewHeader: UIHeaderView!
    
    private var mExtrabold: UIFont? = nil
    private var mNextSheep: Sheep? = nil
    private var mPlayer: AVAudioPlayer? = nil
    
    private weak var mPrevc: UITextViewPhrase? = nil
    
    deinit {
        Log.d("SheepCounterViewController: deinit()")
    }
    
    override func viewDidDisappear(
        _ animated: Bool
    ) {
        Log.d(TAG, "viewDidDisappear")
        mPlayer?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(
            forResource: "sheep_m",
            withExtension: ".mp3"
        )
        
        mPlayer = try? AVAudioPlayer(
            contentsOf: url!,
            fileTypeHint: AVFileType.mp3.rawValue
        )
        mPlayer?.numberOfLoops = -1
        mPlayer?.prepareToPlay()
        
        view.backgroundColor = UIColor(
            named: "background"
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        mExtrabold = UIFont.extrabold(
            withSize: w * 0.086)
        
        mViewHeader = ViewUtils.createHeader(
            frame: view.frame,
            title: "Счётчик\nовечек...",
            subtitle: "Считай бесконечных овечек, чтобы\nлучше уснуть.",
            subtitleSize: 0.041
        )
        
        mViewHeader.frame.origin.y = mInsets.top
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.168
            )
        
        let ofx = w * 0.217
        mLabelTap = UILabel(
            frame: CGRect(
                x: ofx,
                y: h * 0.75,
                width: w-ofx*2,
                height: 0
            )
        )
        
        mLabelTap.numberOfLines = 0
        mLabelTap.font = UIFont(
            name: "OpenSans-SemiBold",
            size: w * 0.04
        )
        mLabelTap.text = "Нажимай на экран и считай овечек."
        mLabelTap.textColor = .white
        mLabelTap.textAlignment = .center
        mLabelTap.sizeToFit()
        
        mLabelTap.frame.origin.x =
            (w-mLabelTap.frame.width) * 0.5
        
        mNextSheep = createSheep()
        
        view.addSubview(mNextSheep!)
        view.addSubview(mLabelTap)
        view.addSubview(mViewHeader)
        view.addSubview(btnClose)
        
        let g = UITapGestureRecognizer(
            target: self,
            action: #selector(onTap(_:))
        )
        
        g.numberOfTapsRequired = 1
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addGestureRecognizer(
            g
        )
        
        btnClose.addTarget(
            self,
            action: #selector(
                onClickBtnExit(_:)
            ),
            for: .touchUpInside
        )
    }
    
}


extension SheepCounterViewController {
    
    @objc private func onClickBtnExit(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        pop(
            duration: 0.5
        ) { [weak self] in
            self?.view.alpha = 0
        }
    }
    
    @objc private func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        
        if mCounter == 1 {
            UIView.animate(
                withDuration: 0.7,
                animations: { [weak self] in
                    self?.mViewHeader.alpha = 0.0
                    self?.mLabelTap.alpha = 0.0
                }
            ) { [weak self] _ in
                self?.mViewHeader
                    .removeFromSuperview()
                
                self?.mLabelTap
                    .removeFromSuperview()
            }
            
            let inst = AVAudioSession
                .sharedInstance()
            try? inst.setActive(true)
            try? inst
                .setCategory(.playback, mode: .default)
            
            mPlayer?.play()
        }
        
        let f = view.frame
        
        let sheep = createSheep()
        
        sheep.jump(
            onX: -f.width - sheep.frame.width*2
        )
        
        view.addSubview(sheep)
        
        mNextSheep?.jumpAnim(
            onX: f.width / 2
        )
        
        sheep.landAnim()
        
        mNextSheep = sheep
        
        let textNumber = UITextViewPhrase(
            frame: CGRect(
                x: 0,
                y: f.height * 0.7,
                width: f.width,
                height: 0
            ), String(mCounter)
        )
        
        textNumber.textColor = .white
        textNumber.font = mExtrabold
        
        view.addSubview(textNumber)
        
        textNumber.attribute()
        textNumber.sizeToFit()
        
        textNumber.centerH(
            in: view
        )
        
        textNumber.show(
            duration: 0.8
        )
        
        mPrevc?.hide(
            duration: 1.0,
            300)
        
        mPrevc = textNumber
        
        mCounter += 1
    }
    
    private func createSheep() -> Sheep {
        
        let f = view.frame
        let sizeSheep = f.width * 0.396
        
        return Sheep(
            frame: CGRect(
                x: (f.width - sizeSheep) * 0.5,
                y: (f.height - sizeSheep) * 0.5,
                width: sizeSheep,
                height: sizeSheep
            )
        )
        
    }
    
}
