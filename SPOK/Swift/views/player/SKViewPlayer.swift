//
//  SKViewPlayer.swift
//  SPOK
//
//  Created by GoodDamn on 09/10/2024.
//

import UIKit

final class SKViewPlayer
: UIView {
    
    private let mImagePlay = UIImage(
        systemName: "play.fill"
    )
    
    private let mImagePause = UIImage(
        systemName: "pause.fill"
    )
    
    private let mImageBack = UIImage(
        systemName: "backward.end.fill"
    )
    
    private let mImageNext = UIImage(
        systemName: "forward.end.fill"
    )

    var isPlaying: Bool {
        get {
            mBtnPlay.image == mImagePlay
        }
        set(plays) {
            if plays {
                mBtnPlay.image = mImagePause
            } else {
                mBtnPlay.image = mImagePlay
            }
        }
    }
    
    var onClickPlay: ((UIView) -> Void)? {
        get {
            mBtnPlay.onClick
        }
        
        set(v) {
            mBtnPlay.onClick = v
        }
    }
    
    var onClickBack: ((UIView) -> Void)? {
        get {
            mBtnBack.onClick
        }
        
        set(v) {
            mBtnBack.onClick = v
        }
    }
    
    var onClickNext: ((UIView) -> Void)? {
        get {
            mBtnNext.onClick
        }
        
        set(v) {
            mBtnNext.onClick = v
        }
    }
    
    private let mBtnPlay = UIImageButton()
    private let mBtnBack = UIImageButton()
    private let mBtnNext = UIImageButton()
    
    private func ini() {
        setupPlayButton()
        
        setupMoveButton(
            btn: mBtnBack,
            image: mImageBack
        )
        
        setupMoveButton(
            btn: mBtnNext,
            image: mImageNext
        )
        
        mBtnNext.frame.origin.x = frame.width
            - mBtnNext.frame.width
    }
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        ini()
    }
    
    required init?(coder: NSCoder) {
        super.init(
            coder: coder
        )
        ini()
    }
}

extension SKViewPlayer {
    
    private func setupPlayButton() {
        mBtnPlay.frame = CGRect(
            x: 0,
            y: 0,
            width: frame.height,
            height: frame.height
        )
        
        mBtnPlay.layer.cornerRadius = mBtnPlay
            .height() * 0.5
        
        mBtnPlay.image = mImagePlay
        mBtnPlay.scale = CGPoint(
            x: 0.65,
            y: 0.65
        )
        mBtnPlay.tintColor = .accent3()
        mBtnPlay.backgroundColor = .accent2()
        
        mBtnPlay.clipsToBounds = true
        
        mBtnPlay.centerH(
            in: self
        )
        
        addSubview(
            mBtnPlay
        )
    }
    
    private func setupMoveButton(
        btn: UIImageButton,
        image: UIImage?
    ) {
        let size = frame.height * 0.6
        btn.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: size,
                height: size
            )
        )
        
        btn.image = image
        btn.scale = CGPoint(
            x: 0.35,
            y: 0.35
        )
        btn.tintColor = .accent2()
        btn.backgroundColor = .clear
        
        btn.centerY(
            in: self
        )
        
        addSubview(
            btn
        )
    }
    
}
