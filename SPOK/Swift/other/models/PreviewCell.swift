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
    
    @IBOutlet weak var mImageView: UIImageView!;
    @IBOutlet weak var mTitle: UILabel!;
    @IBOutlet weak var mDesc: UILabel!;
    
    private var mId: Int = Int.min
    
    deinit {
        print(
            PreviewCell.TAG,
            "deinit()"
        )
    }
    
    public func load(
        type: String,
        id: Int
    ) {
        mId = id
        let s = Storage
            .storage()
            .reference(
                withPath: "Trainings/\(id)/\(type).spc"
            )
        
        s.getData(maxSize: 3*1024*1024) {
            [weak self] data,error in
                
            guard let s = self else {
                print("PreviewCell: getData: garbage collected")
                return
            }
                
            guard let data = data,
                    error == nil else {
                print(PreviewCell.TAG,"ERROR:",error)
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
                
            let fileSPC = Utils.Exten
                    .getSPCFile(data);
                        
            StorageApp.Topic.Save
                .preview(
                    name: "\(s.mId)",
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
        }
    }
    
}
