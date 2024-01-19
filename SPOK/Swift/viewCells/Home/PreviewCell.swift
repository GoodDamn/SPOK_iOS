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
    
    public var mImageView: UIImageView!
    public var mTitle: UILabel!
    public var mDesc: UILabel!
    public var mParticles: Particles!
    
    private var mId: Int = Int.min
    
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
        
        mParticles = Particles()
        
        mParticles.backgroundColor = .black
            .withAlphaComponent(0.4)
        
        
        mImageView = UIImageView()
        mImageView.backgroundColor = .darkGray
        
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
        ini()
    }
    
    public func calculateBounds(
        with size: CGSize
    ) {
        let w = size.width
        let h = size.height
        
        mImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: w,
            height: h
        )
        
        contentView.frame = mImageView.frame
        
        let wtext = 0.867 * w
        
        let ltext = (w - wtext) * 0.5
        
        mTitle.font = mTitle.font
            .withSize(0.096 * h)
        
        mDesc.font = mDesc.font
            .withSize(0.053 * h)
        
        mTitle.frame = CGRect(
            x: ltext,
            y: 0,
            width: wtext,
            height: mTitle.textHeight(
                width: wtext
            )
        )
        mTitle.backgroundColor = .blue
        mDesc.backgroundColor = .gray
        
        mDesc.frame = CGRect(
            x: ltext,
            y: h,
            width: wtext,
            height: mDesc.textHeight(
                width: wtext
            )
        )
        
        let ht = mTitle.frame.height
        let hd = mDesc.frame.height
        
        mTitle.frame.origin.y = h - ht - hd
        mTitle.frame.size.height = ht
        
        mDesc.frame.origin.y = h - ht
        mDesc.frame.size.height = hd
        
        print(PreviewCell.TAG,
              "FRAME:",
              mTitle.frame,
              mDesc.frame
        )
        
        mParticles.frame = mImageView.frame
        mParticles.mRadius = 0.02
        mParticles.generate()
    
        mTitle.setNeedsDisplay()
        mDesc.setNeedsDisplay()
    }
    
    public func load(
        type: String,
        id: Int
    ) {
        mId = id
        
        let d = StorageApp
            .preview(
                id: id
            )
        print(PreviewCell.TAG, "PREVIEW:",d)
        if d != nil {
            show(d!)
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
                id: mId
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
                
            var fileSPC = Utils.Exten
                    .getSPCFile(data);
            
            StorageApp
                .preview(
                    id: s.mId,
                    data: data
                );
            
            s.show(fileSPC)
        }
        
    }
    
    private func show(
        _ fileSPC: FileSPC
    ) {
        DispatchQueue
            .main
            .async { [weak self] in
            
                guard let s = self else {
                    print("PreviewCell: mainAsync: GC")
                    return
                }
                
                let img = Utils
                    .changeSizeOfImage(
                        s.frame.size,
                        image: fileSPC.image!
                    )
                
                s.mImageView.image = img
            
                let sa = s.contentView.layer.bounds
                                
                let layer = s.contentView.layer
                
                layer.cornerRadius = sa.height * 0.1
                
                layer.masksToBounds = true
                
                UIView.animate(
                    withDuration: 0.75
                ) {
                    s.contentView.alpha = 1.0
                }
                
                guard let title = s.mTitle else {
                    return
                }
                
                title.text = fileSPC.title
                title.textColor = fileSPC.color
                
                s.mDesc.text = fileSPC
                    .description
                s.mDesc.textColor = fileSPC.color
                
                guard let part = s.mParticles else {
                    return
                }

                part.isHidden = true
                part.stop()
                
                if Bool.random() {
                    part.isHidden = false
                    part.start()
                }
                
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
