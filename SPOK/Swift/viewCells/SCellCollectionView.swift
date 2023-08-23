//
//  SCellCollectionView.swift
//  SPOK
//
//  Created by Cell on 16.11.2022.
//

import UIKit;
import FirebaseDatabase;
import FirebaseStorage;

class SCellCollectionView: UICollectionViewCell{
    @IBOutlet weak var imageViewTraining: UIImageView!;
    @IBOutlet weak var nameTraining: UILabel!;
    
    private static let TAG = "SCellCollectionView:";
    private var viewController:UIViewController!;
    
    var mID: Int = Int.min;
    var mFileSPC: FileSPC!;
    var collectionView: UICollectionView? = nil;
    var touch:UITouch!;
    var handlerDoubleTap:(()->Void)? = nil;
    
    func reloadView(_ v:UIView,reloadDataHandler: @escaping(()->Void))->Void{
        UIView.animate(withDuration: 0.25, animations: {
            v.alpha = 0.0;
        }, completion: {
            b in
            reloadDataHandler();
            UIView.animate(withDuration: 0.16, animations: {
                v.alpha = 1.0;
            });
        });
    }
    
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        print("SCellCollectionView: single Tap");
        var cardLoc = sender.location(in: self);
        let screenLoc = sender.location(in: self.viewController.view);
        cardLoc.x = cardLoc.x*1.15;
        cardLoc.y = cardLoc.y*1.15;
        Utils.singleTap(self,
                        origin: CGPoint(
                            x: screenLoc.x-cardLoc.x,
                            y: screenLoc.y-cardLoc.y));
    }
    
    @objc func doubleTap(_ sender: UITapGestureRecognizer) {
        print("SCellCollectionView: double Tap");
        handlerDoubleTap?();
    }
    
    private func config() {
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5);
        layer.shadowColor = UIColor(named: "AccentColor")?.cgColor;
        layer.shadowRadius = 5.0;
        layer.shadowOpacity = 0.0;
        layer.masksToBounds = false;
        contentView.layer.cornerRadius = 17.0;
        
        let single = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)));
        single.numberOfTapsRequired = 1;
        addGestureRecognizer(single);
        
        let doubleTouch = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)));
        doubleTouch.numberOfTapsRequired = 2;
        addGestureRecognizer(doubleTouch);
        
        single.require(toFail: doubleTouch);
    }
    
    func load(id: Int,
              nameSize: CGFloat,
              viewController:UIViewController?,
              etc: ((FileSPC)->Void)? = nil,
              type: String = StorageApp.mCardChild,
              lang:String = "") {
        
        guard let viewController = viewController else {
            return;
        }
        
        self.contentView.alpha = 0;
        
        imageViewTraining.image = nil;
        nameTraining.text = nil;
        
        mID = id;
        self.viewController = viewController;

        let name = lang+type+id.description;
        
        if StorageApp.Topic.fileExist(cachePath: name+".spc") {
            
            DispatchQueue.global(qos: .background).async {
                print("SCELL_COLLECTION_VIEW: GETTING PREVIEW FROM STORAGE:", id);
                
                let fileSPC = StorageApp.Topic.preview(name: name) ?? FileSPC();
                self.mFileSPC = fileSPC;
                
                DispatchQueue.main.async {
                    self.nameTraining.text = fileSPC.title;
                    self.imageViewTraining.image = fileSPC.image;
                    self.nameTraining.textColor = fileSPC.color;
                    
                    etc?(fileSPC);
                    Utils.showCard(self);
                }
            }
            return;
        }
        
        
        Storage.storage()
            .reference(withPath: "Trainings/"+id.description+"/"+lang+type+".spc")
            .getData(maxSize: 3*1024*1024) { data,error in
                if error != nil || data == nil {
                    return;
                }
                
                DispatchQueue.global(qos: .background).async {
                    let fileSPC = Utils.Exten.getSPCFile(data!);
                    self.mFileSPC = fileSPC;
                    var img: UIImage? = fileSPC.image;
                    
                    if (self as? MCellCollectionView == nil) {
                        let w = img!.size.width;
                        img = Utils.cropImage(CGSize(width: w, height: w),
                                              input: img);
                    }
                    
                    StorageApp.Topic.Save.preview(name: name,
                                                  data: data);
                    
                    DispatchQueue.main.async {
                        
                        img = Utils.changeSizeOfImage(self.layer.frame.size, image: img!);
                        
                        self.imageViewTraining.image = img;
                        
                        self.nameTraining.text = fileSPC.title;
                        self.nameTraining.textColor = fileSPC.color;
                        etc?(fileSPC);
                        Utils.showCard(self);
                    }
                }
            }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.config();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        self.config();
    }
}
