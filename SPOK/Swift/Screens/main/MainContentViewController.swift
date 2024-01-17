//
//  ManagerViewController.swift
//  SPOK
//
//  Created by Cell on 26.06.2022.
//

import UIKit;
import Network;
import FirebaseDatabase;
import FirebaseAuth;
import UserNotifications;

class MainContentViewController
    : StackViewController {
    
    private let tag = "MainContentViewController:";
    
    @IBOutlet weak var pageContainer: UIView!;
    
    let language = Utils.getLanguageCode();
    let mDatabase = Database.database();
    
    var mNavBar: BottomNavigationBar!;
    
    var blurView = UIVisualEffectView(
        effect: UIBlurEffect(
            style: .systemChromeMaterial)
    );
    
    var news: [UInt16] = [];
    var history: [UInt16] = []{
        didSet{
            StorageApp.mUserDef
                .setValue(history, forKey: StorageApp.historyKey);
        }
        
    }
    
    var likes: [UInt16] = []{
        didSet{
            StorageApp.mUserDef.setValue(likes, forKey: StorageApp.likesKey);
        }
    }
    var recommends: [UInt16] = []{
        didSet{
            StorageApp.mUserDef.setValue(recommends, forKey: StorageApp.recommendsKey);
        }
    }
    var isPremiumUser: Bool = false;
    var isAuthUser: Bool = false;
    var freeTrialState: UInt8 = 0; // 0 - no free trial, 1 - is active, 2 - expired
    var isConnected: Bool = false;
    var isLoadMetaData: Bool = false;
    var pageViewController: MainPageViewController? = nil;
    
    var mDatabaseStats: DatabaseReference? = nil;
    var mDatabaseUser: DatabaseReference? = nil;
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if (segue.identifier == "mainPage") {
            let storyboard = UIStoryboard(name: "mainNav", bundle: nil);
            pageViewController = segue.destination as? MainPageViewController;
            pageViewController?.mPages = [
                storyboard.instantiateViewController(withIdentifier: "home"),
                //storyboard.instantiateViewController(withIdentifier: "search"),
                storyboard.instantiateViewController(withIdentifier: "profile")
            ]
            return;
        }
        
    }
    
    @objc func onPause(){
        print(tag, "onPause();");
        /*DispatchQueue.global(
            qos: .userInitiated
        ).async {
            let userRef = StorageApp
                .mUserDef
                .string(
                    forKey: Utils
                        .userRef
                );
            
            if userRef != nil
                && self.isConnected
                && self.isLoadMetaData
                && self.isAuthUser {
                let dataRef = Database.database().reference(withPath: "Users/"+userRef!);
                dataRef.child("his2").setValue(Crypt.encryptString(self.history));
                dataRef.child("like2").setValue(Crypt.encryptString(self.likes));
                dataRef.child("rec2").setValue(Crypt.encryptString(self.recommends));
            }
        }*/
    }
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        print(self.tag, "viewWillAppear()",view.subviews);
        
        if view.subviews[1] is BottomNavigationBar {
            return;
        }
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(onPause),
                name: UIApplication
                    .willResignActiveNotification
                ,object: nil
            );
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print(tag, "viewDidLoad()")
        
        mDatabaseStats = mDatabase.reference(withPath: "Stats/iOS");
        
        isAuthUser = Auth.auth().currentUser != nil;
        
        history = StorageApp
            .mUserDef
            .array(
                forKey: StorageApp.historyKey
            ) as? [UInt16] ?? [];
        
        likes = StorageApp
            .mUserDef
            .array(
                forKey: StorageApp.likesKey
            ) as? [UInt16] ?? [];
        
        recommends = StorageApp
            .mUserDef
            .array(
                forKey: StorageApp.recommendsKey
            ) as? [UInt16] ?? [];
        
        let ref = mDatabase.reference();
        
        
        let b = UIScreen
            .main
            .bounds
            .size;
        
        let hBar:CGFloat = 50;
        let imageSize = CGSize(
            width: 60,
            height: 50
        );
        
        let bottomPadding = UIApplication.shared
            .windows
            .first?
            .safeAreaInsets
            .bottom ?? 0;
        
        mNavBar = BottomNavigationBar(
            frame: CGRect(
                x: 0,
                y: b.height-hBar-bottomPadding,
                width: b.width,
                height: hBar)
        );
        mNavBar.backgroundColor = UIColor(
            named: "background"
        );
        
        mNavBar.mOffset = 30;
        mNavBar.mTintColorSelected = UIColor(
            named:"AccentColor"
        );
        
        mNavBar.mOnSelectTab = { index in
            self.pageViewController?
                .mIndex = index
        }
        
        view.addSubview(mNavBar);
        
        createTab(systemNameImage: "house", imageSize: imageSize);
        /*createTab(systemNameImage: "magnifyingglass", imageSize: imageSize);*/
        createTab(
            systemNameImage: "person.fill",
            imageSize: imageSize
        );
        
        mNavBar.subviews[0]
            .tintColor = UIColor(
                named: "AccentColor"
            );
        
        mNavBar.center_vertical();
        mNavBar.center_horizontal();
        
     }
    
    func startTraining(
        cell:SCellCollectionView,
        startFrame:CGRect,
        endOfSession:((Int)->Void)? = nil
    ) {
        
        let id = cell.mID;
        let name:String? = cell.nameTraining.text;
        
        print("startTraining", id, name)
        if id == 0 || name == nil{
            return;
        }
        
        let lang = language.isEmpty ? "RU" : language;
        
        var statsTopic = id.description + "/\(lang)/";
        var statsCategory = cell.mFileSPC.categoryID.description + "/\(lang)/";
        
        if (id > 0){
            let uint16ID = UInt16(id);
            let indexExists = history.firstIndex(of: uint16ID);
            if indexExists != nil {
                statsTopic += "R_";
                statsCategory += "R_";
                history.remove(at: indexExists!);
            }
            history.append(uint16ID);
        }
        
        let controller = BaseTopicController()
        
        controller.setID(
            id
        )
        
        navigationController?
            .pushViewController(
                controller,
                animated: true
            )
        
    }
    
    
    func showSubScreen()->Void {
    }
    
    private func createTab(
        systemNameImage: String,
        imageSize: CGSize
    ) {
        
        let iv = UIButton(
            frame: CGRect(
                origin: .zero,
                size: imageSize
            )
        )
        
        let config = UIImage.SymbolConfiguration(
            pointSize: imageSize.height*0.42,
            weight: .regular,
            scale: .medium
        )
        iv.setImage(
            UIImage(
                systemName: systemNameImage,
                withConfiguration: config
            ),
            for: .normal
        )// person.fill | house
        iv.tintColor = .lightGray;
        iv.backgroundColor = .clear;
        
        mNavBar.addTab(iv);
    }
}
