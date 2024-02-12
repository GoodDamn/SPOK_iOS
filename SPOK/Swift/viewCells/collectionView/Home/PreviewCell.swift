//
//  PreviewCell.swift
//  SPOK
//
//  Created by GoodDamn on 15/01/2024.
//

import Foundation
import UIKit
import FirebaseStorage

class PreviewCell
    : UICollectionViewCell{
    
    private static let TAG = "PreviewCell:"
    
    public static let ID = "cell"
    
    public var mImageView: UIImageView!
    public var mTitle: UILabela!
    public var mDesc: UILabela!
    public var mParticles: Particles!
    
    public var mCardTextSize: CardTextSize! {
        didSet {
            Log.d(
                PreviewCell.TAG,
                "CARD_TEXT_SIZE:",
                mCardTextSize.title,
                mCardTextSize.desc,
                mDesc.font.pointSize
            )
            
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
    private var mCache: CacheData<FileSPC>? = nil
    private var mCalculated = false
    
    deinit {
        Log.d(
            PreviewCell.TAG,
            "deinit()"
        )
    }
    
    private func ini() {
        Log.d(PreviewCell.TAG,
              "ini:",
              frame
        )
        
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
        contentView.backgroundColor = .clear
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
        
        let g = UITapGestureRecognizer(
            target: self,
            action: #selector(
                onTap(_:)
            )
        )
        
        g.numberOfTapsRequired = 1
        
        contentView.addGestureRecognizer(
            g
        )
        
    }
    
    override init(frame: CGRect) {
        super.init(
            frame: frame
        )
        ini()
        Log.d(PreviewCell.TAG, "init(frame:)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Log.d(PreviewCell.TAG, "init(coder:)")
    }
    
    @objc func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        guard let s = mCache?.object else {
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
        
        Utils.main()
            .push(
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
        mId = id
        mType = type
                
        if mCache?.object != nil {
            show()
            return
        }
        
        if mCache == nil {
            
            let localp = StorageApp
                .previewUrl(
                    id: mId,
                    type: mType
                )
            
            mCache = CacheData(
                pathStorage: "Trainings/\(id)/\(type).spc",
                localPath: localp
            )
                
            mCache!.delegate = self
        }
        
        mCache?.load()
    }
    
    private func calculateBounds() {
        Log.d(
            PreviewCell.TAG,
            "calculated",
            mCalculated
        )
        
        if mCalculated {
            return
        }
        
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
        
        Log.d(
            PreviewCell.TAG,
            "FRAMES_TEXT: TITLE",
            ht,
            mTitle.font.pointSize
        )
        
        Log.d(
            PreviewCell.TAG,
            "FRAMES_TEXT: DESC",
            hd,
            mDesc.font.pointSize
        )
        
        mCalculated = true
    }
    
    private func show() {
        
        guard let fileSPC = mCache?.object else {
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
        if data == nil || mCache == nil {
            return
        }
        
        mCache!.object = Extension
            .spc(&data!)
        
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

extension UILabel {
    
    func textHeight() -> CGFloat {
        return textHeight(
            width: frame.width
        )
    }
    
    func textHeight(
        width: CGFloat
    ) -> CGFloat {
        return systemLayoutSizeFitting(
            CGSize(
                width: frame.width,
                height: UIView
                    .layoutFittingCompressedSize
                    .height
            ),
            withHorizontalFittingPriority:
                    .required,
            verticalFittingPriority:
                    .fittingSizeLevel
        ).height
    }
    
}
