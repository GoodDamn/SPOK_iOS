//
//  MCellCollectionView.swift
//  SPOK
//
//  Created by Cell on 17.04.2022.
//

import UIKit;
import FirebaseDatabase;
class MCellCollectionView
    : SCellCollectionView{

    @IBOutlet weak var descriptionTr: UILabel!;
    @IBOutlet weak var l_new: UILabel!;
    @IBOutlet weak var padlock: UIImageView!;
    @IBOutlet weak var heart: UIImageView!;
    @IBOutlet weak var heartScaling: UIImageView!;
    @IBOutlet weak var heartTop: NSLayoutConstraint!;
    
    func load(
        id:Int,
        type:String = StorageApp.mCardChild,
        lang:String,
        nameSize:CGFloat,
        descSize: CGFloat
    ) {
        self.handlerDoubleTap = {
            print("MCellCollectionView", "double tap");
            
            /*let id16 = UInt16(id);
            let index = manager.likes.firstIndex(of: id16);
            if index != nil {
                manager.likes.remove(at: index!);
                anager.mDatabaseStats?
                    .child("Likes/"+id16.description)
                    .setValue(ServerValue.increment(-1));
                UIView.animate(withDuration: 0.23, animations: {
                    self.heart.alpha = 0.0;
                    self.heart.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
                });
            } else {
                manager.likes.append(id16);
                /*manager.mDatabaseStats?
                    .child("Likes/"+id16.description)
                    .setValue(ServerValue.increment(1));*/
                self.heart.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
                self.heartScaling.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                self.heartScaling.alpha = 1.0;
                UIView.animate(withDuration: 0.23, animations: {
                    self.heart.alpha = 1.0;
                    self.heart.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                    self.heartScaling.alpha = 0.0;
                    self.heartScaling.transform = CGAffineTransform(scaleX: 5.0, y: 5.0);
                });
            }*/
        }
        
        super.load(
            id: id,
            nameSize: nameSize,
            etc: { fileSPC in
                self.descriptionTr.textColor = fileSPC.color;
            print(
                "MCELL_COLLECTION_VIEW:",
                fileSPC.description,
                fileSPC.color
            );
            self.descriptionTr.text = fileSPC.description;
            self.descriptionTr.font = self
                    .descriptionTr
                    .font?.withSize(descSize + UIScreen.main.nativeScale);
                
                        /*Storage.mkdir(path: Storage.Topic.getTopicsURL().appendingPathComponent(id.description, isDirectory: true).path);*/
                
                        /*if manager.likes.contains(UInt16(id)){
                            self.heart.alpha = 1.0;
                        }
                        TopicsConfig.isNew(id, self);*/
                        TopicsConfig.isPremium(id, self, isPrem: fileSPC.isPremium);
                   },
                   type: type,
                   lang: lang);
    }
}
