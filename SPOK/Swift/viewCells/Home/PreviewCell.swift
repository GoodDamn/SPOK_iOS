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
    public var mTitle: UILabel!
    public var mDesc: UILabel!
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
    
    private var mFileSpc: FileSPC? = nil
    private var mId: Int = Int.min
    private var mType: CardType = .M
    
    private var mCache: CacheFile? = nil
    
    deinit {
        print(
            PreviewCell.TAG,
            "deinit()"
        )
    }
    
    private func ini() {
        print(PreviewCell.TAG,
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
        
        mTitle = UILabel()
        mTitle.font = bold
        mTitle.numberOfLines = 0
        mTitle.textColor = .white
        mTitle.backgroundColor = .clear
        
        mDesc = UILabel()
        mDesc.font = bold
        mDesc.numberOfLines = 0
        mDesc.textColor = .white
        mDesc.backgroundColor = .clear
        
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
        
        print(PreviewCell.TAG, "init(frame:)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(PreviewCell.TAG, "init(coder:)")
    }
    
    @objc func onTap(
        _ sender: UITapGestureRecognizer
    ) {
        let t = BaseTopicController()
        t.setID(mId)
        t.view.alpha = 0.0
        
        guard let s = mFileSpc else {
            return
        }
        
        if s.isPremium {
            return
        }
        
        Utils.main()
            .push(
                t,
                animDuration: 0.3
            ) {
                t.view.alpha = 1.0
            }
        
    }
    
    public func calculateBounds() {
        
        let w = frame.width
        let h = frame.height
        
        let wtext = 0.867 * w
        
        let ltext = (w - wtext) * 0.5
        
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
        
        print(PreviewCell.TAG,
              "FRAMES_TEXT: TITLE",
              ht,
              mTitle.font.pointSize
        )
        
        print(PreviewCell.TAG,
              "FRAMES_TEXT: DESC",
              hd,
              mDesc.font.pointSize
        )
        
    }
    
    public func load(
        type: CardType,
        id: Int
    ) {
        mId = id
        mType = type
        
        if mFileSpc != nil {
            show(&mFileSpc!)
            return
        }
        
        if mCache == nil {
            
            let localp = StorageApp
                .previewUrl(
                    id: mId,
                    type: mType
                )
            
            mCache = CacheFile(
                pathStorage: "Trainings/\(id)/\(type).spc",
                localPath: localp.pathh()
            )
                
            mCache!.delegate = self
        }
        
        mCache?.load()
    }
    
    public func setText(
        _ text: String,
        color: UIColor?,
        font: UIFont?
    ) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(
            string: text
        )
        
        let parag = NSMutableParagraphStyle()
        parag.lineHeightMultiple = 0.83
        
        let range = NSRange(
            location: 0,
            length: text.count
        )
        
        attr.addAttribute(
            .font,
            value: font,
            range: range
        )
        
        attr.addAttribute(
            .foregroundColor,
            value: color,
            range: range
        )
        
        attr.addAttribute(
            .paragraphStyle,
            value: parag,
            range: range
        )
        
        return attr
    }
    
    
    private func show(
        _ fileSPC: inout FileSPC
    ) {
        
        let img = Utils
            .changeSizeOfImage(
                frame.size,
                image: fileSPC.image!
            )
        
        mImageView.image = img
    
        let sa = contentView.layer.bounds
                        
        let layer = contentView.layer
        layer.cornerRadius = sa.height * 0.1
        layer.masksToBounds = true
        
        mTitle.attributedText = setText(
            fileSPC.title ?? "",
            color: fileSPC.color,
            font: mTitle.font
        )
        
        mDesc.attributedText = setText(
            fileSPC.description ?? "",
            color: fileSPC.color,
            font: mDesc.font
        )
        
        calculateBounds()
        
        if let part = mParticles {
            part.isHidden = true
            part.stop()
            
            if fileSPC.isPremium {
                part.isHidden = false
                part.start()
            }
        }
        
        UIView.animate(
            withDuration: 0.75
        ) {
            self.contentView.alpha = 1.0
        }
        
    }
    
}

extension PreviewCell
: CacheListener {
    
    // Background thread
    func onFile(
        data: inout Data?
    ) {
        if data == nil {
            return
        }
        
        mFileSpc = Utils
            .Exten
            .getSPCFile(
                &data!
            )
        
        DispatchQueue
            .main
            .async {
                self.show(
                    &self.mFileSpc!
                )
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
