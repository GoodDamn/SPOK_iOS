//
//  UICollectionViewCellTopic.swift
//  SPOK
//
//  Created by GoodDamn on 15/01/2024.
//

import Foundation
import UIKit

final class UICollectionViewCellTopic
: UICollectionViewCell {
    
    private static let TAG = "UICollectionViewCellTopic:"
    
    static let ID = "topicCell"
    
    private var mImageView: UIImageView!
    private var mTitle: UILabela!
    private var mDesc: UILabela!
    private var mParticles: Particles!
    
    private let mServicePreview = SKServiceTopicPreviews()
    private var mPreviewId = Int.min
    
    var cardTextSize: CardTextSize! {
        didSet {
            if cardTextSize.desc == mDesc.font.pointSize {
                return
            }
            
            mTitle.font = mTitle.font.withSize(
                cardTextSize.title
            )
            
            mDesc.font = mDesc.font.withSize(
                cardTextSize.desc
            )
        }
    }
    
    override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )
        
        mServicePreview.delegate = self
        
        let f = CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: frame.height
        )
        
        mParticles = Particles(
            frame: f,
            radius: 0.01
        )
        
        contentView.clipsToBounds = true
        
        mParticles.backgroundColor = .black
            .withAlphaComponent(0.4)
        
        mImageView = UIImageView(
            frame: f
        )
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        mImageView.backgroundColor = .clear
        
        let bold = UIFont.bold(
            withSize: 18
        )
        
        mTitle = UILabela()
        mTitle.font = bold
        mTitle.numberOfLines = 0
        mTitle.textColor = .white
        mTitle.backgroundColor = .clear
        mTitle.lineHeight = 0.83
        
        mDesc = UILabela()
        mDesc.font = bold
        mDesc.numberOfLines = 0
        mDesc.textColor = .white
        mDesc.backgroundColor = .clear
        mDesc.lineHeight = 0.83
        
        contentView.addSubview(
            mImageView
        )
        
        contentView.addSubview(
            mTitle
        )
        
        contentView.addSubview(
            mDesc
        )
        
        contentView.addSubview(
            mParticles
        )
        
        mParticles.isHidden = true
        mParticles.stop()
    }
    
    required init?(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
    }
    
    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let _ = touches.first else {
            return
        }
        
        if !mParticles.isHidden && !MainViewController
            .mIsPremiumUser {
            // Move to sub page
            Toast.show(
                text: "Доступно только с подпиской"
            )
            return
        }
        
        let t = BaseTopicController()
        t.topicId = mPreviewId
        t.view.alpha = 0.0
        
        Utils.main().push(
            t,
            animDuration: 0.3
        ) { [weak self] in
            t.view.alpha = 1.0
        }
        
    }
    
}

extension UICollectionViewCellTopic {
    
    final func stopParticles() {
        mParticles.stop()
        mParticles.isHidden = true
    }
    
    final func layout(
        with size: CGSize
    ) {
        contentView.layer.cornerRadius = size
            .height * 0.09
        
    }
    
    final func loadData(
        previewId: Int,
        type: CardType
    ) {
        mPreviewId = previewId
        mServicePreview.getTopicPreview(
            id: previewId,
            type: type
        )
    }
    
    private final func calculateBoundsText() {
        
        let w = frame.size.width
        let h = frame.size.height
        
        let ltext = w * 0.083
        
        let wtext = w - ltext
        
        mTitle.frame = CGRect(
            x: ltext,
            y: 0,
            width: wtext,
            height: 1
        )
        
        mDesc.frame = mTitle.frame
        
        mTitle.sizeToFit()
        mDesc.sizeToFit()
                
        let ht = mTitle.frame.height
        let hd = mDesc.frame.height
        
        let bottom = 0.104 * h
        let between = 0.02 * h
        let y2 = h - hd - bottom
        let y1 = y2 - ht - between
        
        mDesc.frame.origin.y = y2
        mTitle.frame.origin.y = y1
    }
}

extension UICollectionViewCellTopic
: SKDelegateOnGetTopicPreview {
 
    func onGetTopicPreview(
        preview: SKModelTopicPreview
    ) {
        mTitle.text = preview.title
        mDesc.text = preview.desc
        
        calculateBoundsText()
        
        if preview.isPremium {
            mParticles.start()
            mParticles.isHidden = false
        }
        
        mImageView.image = preview.preview?.size(
            frame.size
        )
        
        animate(
            animations: {
                [weak self] in
                self?.alpha = 1.0
            }
        )
    }
    
}
