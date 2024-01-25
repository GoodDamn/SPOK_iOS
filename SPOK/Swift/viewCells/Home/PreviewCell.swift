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
    : UICollectionViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print(PreviewCell.TAG, "prepareForReuse", mTitle.bounds.height)
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
        
        if mFileSpc == nil {
            DispatchQueue
                .global(
                    qos: .background
                ).async { [weak self] in
                    
                    guard let s = self else {
                        return
                    }
                    
                    s.mFileSpc = StorageApp
                        .preview(
                            id: id,
                            type: type
                        )
                    if s.mFileSpc == nil {
                        return
                    }
                    
                    DispatchQueue
                        .main
                        .async {
                            s.show(&s.mFileSpc!)
                        }
                }
        } else {
            show(&mFileSpc!)
        }
        
        let st = Storage
            .storage()
            .reference(
                withPath: "Trainings/\(id)/\(type).spc"
            )
        
        st.getMetadata { [weak self]
            meta, error in
            
            guard let s = self else {
                print(PreviewCell.TAG,"getMetadata: garbage collected")
                return
            }
            
            guard let meta = meta, error == nil else {
                print(PreviewCell.TAG, "ERROR_META:",error)
                return
            }
            
            s.processMetadata(
                meta,
                file: st
            )
            
        }
        
    }
    
    private func processMetadata(
        _ meta: StorageMetadata,
        file: StorageReference
    ) {
       
        let p = StorageApp.rootPath(
            append: StorageApp.mDirPreviews
        ).append(
            StorageApp.tospc(
                id: mId,
                type: mType
            )
        )

        let t = StorageApp.modifTime(
            path: p.pathh()
        )
        
        let nett = meta.updated?.timeIntervalSince1970 ?? 0
        
        print(PreviewCell.TAG, "meta:",t,nett)
        if t >= nett {
            return
        }
        
        file.getData(maxSize: 3*1024*1024) {
            [weak self] data,error in
                
            guard let s = self else {
                print("PreviewCell: getData: garbage collected")
                return
            }
                
            guard let data = data,
                    error == nil else {
                print(
                    PreviewCell.TAG,
                    "ERROR:",
                    error)
                return
            }
            
            s.extractSpc(
                from: data
            )
            
        }
        
    }
    
    private func extractSpc(
        from data: Data
    ) {
        DispatchQueue.global(
            qos: .background
        ).async { [weak self] in

            guard let s = self else {
                print("PreviewCell: extractSpc: gc")
                return
            }
                
            s.mFileSpc = Utils.Exten
                    .getSPCFile(data);
            
            StorageApp
                .preview(
                    id: s.mId,
                    type: s.mType,
                    data: data
                );
            
            DispatchQueue
                .main
                .async {
                    s.show(&s.mFileSpc!)
                }
        }
        
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
        
        mTitle.text = fileSPC.title
        mTitle.textColor = fileSPC.color
        
        mDesc.text = fileSPC
            .description
        mDesc.textColor = fileSPC.color

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
