//
//  PreviewCell.swift
//  SPOK
//
//  Created by GoodDamn on 15/01/2024.
//

import Foundation
import UIKit

final class PreviewCell
    : UICollectionViewCell{
    
    private static let TAG = "PreviewCell:"
    
    public static let ID = "cell"
    
    public var mImageView: UIImageView!
    public var mTitle: UILabela!
    public var mDesc: UILabela!
    public var mParticles: Particles!
    
    public var mCardTextSize: CardTextSize! {
        didSet {
            
            if mCardTextSize.desc == mDesc.font.pointSize {
                return
            }
            
            mTitle.font = mTitle.font
                .withSize(
                    mCardTextSize.title
                )
            
            mDesc.font = mDesc.font
                .withSize(
                    mCardTextSize.desc
                )
        }
    }
    
    private var mId: Int = Int.min
    private var mType: CardType = .M
    private var mData: FileSPC? = nil
    private var mCache: CacheData<FileSPC>? = nil
    
    private func ini() {
        
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
        
        mParticles.backgroundColor = .black
            .withAlphaComponent(0.4)
        
        mImageView = UIImageView(
            frame: f
        )
        
        backgroundColor = .clear
        contentView.backgroundColor = .gray
        mImageView.backgroundColor = .clear
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 18
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
        
        contentView
            .addSubview(mImageView)
        contentView
            .addSubview(mTitle)
        contentView
            .addSubview(mDesc)
        contentView
            .addSubview(mParticles)
    }
    
    override init(frame: CGRect) {
        super.init(
            frame: frame
        )
        ini()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let _ = touches.first else {
            return
        }
        
        guard let s = mData else {
            return
        }
        
        if s.isPremium && !MainViewController
            .mIsPremiumUser {
            // Move to sub page
            Toast(
                text: "Доступно только с подпиской",
                duration: 1.5
            ).show()
            
            return
        }
        
        let t = BaseTopicController()
        t.setID(mId)
        t.view.alpha = 0.0
        
        Utils.main().push(
            t,
            animDuration: 0.3
        ) {
            t.view.alpha = 1.0
        }
        
    }
    
    public func load(
        type: CardType,
        id: Int
    ) {
        mData = nil
        mType = type
        mId = id
        
        let localp = StorageApp
            .previewUrl(
                id: mId,
                type: type
            )
        
        mCache = CacheData<FileSPC>(
            pathStorage: "Trainings/\(id)/\(type).spc",
            localPath: localp
        )
        
        mCache?.delegate = self
        mCache?.load()
    }
    
}

extension PreviewCell {
    private func calculateBounds() {
        
        let w = frame.width
        let h = frame.height
        
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
    
    private func show() {
        
        guard let fileSPC = mData else {
            return
        }
        
        if let img = fileSPC.image {
            mImageView.image = img.size(
                frame.size
            )
        }
        
        let sa = contentView.layer.bounds
                        
        let layer = contentView.layer
        layer.cornerRadius = sa.height * 0.1
        layer.masksToBounds = true
        
        mTitle.text = fileSPC.title
        mDesc.text = fileSPC.description
        
        mTitle.attribute()
        mDesc.attribute()
        
        calculateBounds()
        
        manageParticles(
            fileSPC.isPremium
        )
        
        UIView.animate(
            withDuration: 0.75
        ) { [weak self] in
            self?.contentView.alpha = 1.0
        }
        
    }
    
    private func manageParticles(
        _ topicPrem: Bool
    ) {
        if mParticles == nil {
            return
        }
        
        mParticles!.isHidden = true
        mParticles!.stop()
        
        if MainViewController
            .mIsPremiumUser {
            return
        }
        
        if topicPrem {
            mParticles!.isHidden = false
            mParticles!.start()
        }
        
    }
}

extension PreviewCell
: CacheListener {
    
    // Background thread
    func onFile(
        data: inout Data?
    ) {
        print("PreviewCell: onFile", data, mData)
        if data == nil {
            return
        }
        
        mData = Extension.spc(
            &data!
        )
        
        DispatchQueue
            .main
            .async { [weak self] in
                self?.show()
            }
        
    }
    
    // Background thread
    func onNet(
        data: inout Data?
    ) {
        print("PreviewCell: onNet", data)
        // Save data
        StorageApp
            .preview(
                id: mId,
                type: mType,
                data: &data
            )
        
        onFile(
            data: &data
        )
        
    }
    
    func onError() {}
    
}
