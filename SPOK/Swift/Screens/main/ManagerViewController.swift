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

class ManagerViewController: UIViewController{
    
    private let tag = "ManagerViewController:";
    
    @IBOutlet weak var heightSnackbar: NSLayoutConstraint!;
    @IBOutlet weak var heightSnackBarRating: NSLayoutConstraint!;
    @IBOutlet weak var bottomInset: NSLayoutConstraint!;
    
    @IBOutlet weak var trainingContainer: UIView!;
    @IBOutlet weak var pageContainer: UIView!;
    @IBOutlet weak var snackBarRating: UIView!;
    
    private var mPrevIndex:Int = 0;
    
    let language = Utils.getLanguageCode();
    let userDefaults: UserDefaults = UserDefaults();
    let mDatabase = Database.database();
    
    var mNavBar: BottomNavigationBar!;
    var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial));
    var news: [UInt16] = [];
    var history: [UInt16] = []{
        didSet{
            userDefaults.setValue(history, forKey: StorageApp.historyKey);
        }
        
    }
    
    var likes: [UInt16] = []{
        didSet{
            userDefaults.setValue(likes, forKey: StorageApp.likesKey);
        }
    }
    var recommends: [UInt16] = []{
        didSet{
            userDefaults.setValue(recommends, forKey: StorageApp.recommendsKey);
        }
    }
    var isPremiumUser: Bool = false;
    var isAuthUser: Bool = false;
    var freeTrialState: UInt8 = 0; // 0 - no free trial, 1 - is active, 2 - expired
    var isConnected: Bool = false;
    var isLoadMetaData: Bool = false;
    var pageViewController: MainPageViewController? = nil;
    var ratingSnackBar: RatingSnackbar? = nil;
    var viewControllersPages:[UIViewController] = [];
    
    var mDatabaseStats: DatabaseReference? = nil;
    var mDatabaseUser: DatabaseReference? = nil;
    
    func closeFragment() {
        trainingContainer.isHidden = true;
        trainingContainer.subviews[0].removeFromSuperview();
        blurView.removeFromSuperview();
    }
    
    func hideRateSnackBar(){
        self.heightSnackBarRating.constant = 0;
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded();
            self.snackBarRating.alpha = 0.0;
        });
    }
    
    func showNoInternet(cell: SCellCollectionView) {
        let v = UIStoryboard(name:"mainMenu", bundle: nil).instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController;
        v.cell = cell;
        blur();
        showFragment(v.view);
    }
    
    func showFragment(_ v: UIView, completion: ((Bool)->Void)? = nil){
        trainingContainer.addSubview(v);
        UIView.animate(withDuration: 0.6, animations: {
            v.frame = UIScreen.main.bounds;
            v.layer.cornerRadius = 0;
            self.blurView.alpha = 1.0;
        }, completion: completion);
    }
    
    func startTraining(cell:SCellCollectionView,
                       startFrame:CGRect,
                       endOfSession:((Int)->Void)? = nil)->Void{
        
        var endOfTopic = endOfSession;
        
        if (endOfTopic == nil){
            endOfTopic = {
                id in
                
                if !self.isAuthUser {
                    return;
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.heightSnackBarRating.constant = 110;
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded();
                        self.snackBarRating.alpha = 1.0;
                    }, completion: {
                        _ in
                        self.ratingSnackBar?.id = UInt16(id);
                        self.ratingSnackBar?.startTimer();
                    });
                });
            }
        }
        
        let id = cell.mID;
        let name:String? = cell.nameTraining.text;
        
        print("startTraining", id, name)
        if id == 0 || name == nil{
            return;
        }
        blur();
        
        var statsTopic = id.description+"_";
        var statsCategory = cell.mFileSPC.categoryID.description + "_";
        
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
        
        
        let controller = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "training") as! TopicActivity;
        controller.id = id;
        controller.endOfSession = endOfTopic;
        controller.mFileSPC = cell.mFileSPC;
        controller.mStatsTopic = statsTopic;
        controller.mStatsCategory = statsCategory;
        controller.view.frame = startFrame;
        controller.view.layer.masksToBounds = true;
        print("ManagerVC:", controller.view);
        controller.view.layer.cornerRadius = 17*1.15;
        cell.clipsToBounds = true;
        controller.putPreviewImage(cell: cell,startFrame: startFrame);
        cell.clipsToBounds = false;
        showFragment(controller.view,
                     completion: { _ in
            controller.loadData();
        });
        controller.l_nameTraining.text = name;
    }
    
    
    func showSubScreen()->Void {
        let v = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "banner") as! BannerViewController;
        navigationController?.pushViewController(v, animated: true);
        //let v = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "sub") as! SubscriptionViewController;
        //navigationController?.pushViewController(v, animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(tag, "segue.identifier: ",segue.identifier);
        if (segue.identifier == "mainPage"){
            let storyboard = UIStoryboard(name: "mainMenu", bundle: nil);
            viewControllersPages = [
                storyboard.instantiateViewController(withIdentifier: "home"),
                storyboard.instantiateViewController(withIdentifier: "search"),
                storyboard.instantiateViewController(withIdentifier: "profile")
            ];
            pageViewController = segue.destination as? MainPageViewController;
            print(tag, "segue.identifier: mainPage True", pageViewController);
            pageViewController?.setup();
            return;
        }
        
        if segue.identifier == "rate"{
            ratingSnackBar = segue.destination as? RatingSnackbar;
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    @objc func onPause(){
        print(tag, "onPause();");
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = self.userDefaults.string(forKey: Utils.userRef);
            if userRef != nil
                && self.isConnected
                && self.isLoadMetaData
                && self.isAuthUser {
                let dataRef = Database.database().reference(withPath: "Users/"+userRef!);
                dataRef.child("his2").setValue(Crypt.encryptString(self.history));
                dataRef.child("like2").setValue(Crypt.encryptString(self.likes));
                dataRef.child("rec2").setValue(Crypt.encryptString(self.recommends));
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.tag, "viewWillAppear();");
        
        if view.subviews[1] is BottomNavigationBar {
            return;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.willResignActiveNotification, object: nil);
        
        let b = UIScreen.main.bounds.size;
        
        let hBar:CGFloat = 50;
        let imageSize = CGSize(width: 60, height: 50);
        
        var bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0;
        
        mNavBar = BottomNavigationBar(frame: CGRect(x: 0, y: b.height-hBar-bottomPadding, width: b.width, height: hBar));
        mNavBar.backgroundColor = UIColor(named: "background");
        mNavBar.mOffset = 30;
        mNavBar.mTintColorSelected = UIColor(named:"AccentColor");
        mNavBar.mOnSelectTab = { index in
            self.pageViewController?
                .setViewControllers(
                    [self.viewControllersPages[index]],
                    direction: index > self.mPrevIndex ? .forward : .reverse,
                    animated: true,
                    completion: { b in
                        if index == 2 {
                            let profile = (self.viewControllersPages[2] as! UINavigationController)
                                .viewControllers.first as? ProfileViewController;
                            profile?.updateHistory();
                            profile?.updateLikes();
                        }
                        self.mPrevIndex = index;
                    });
        }
        
        view.insertSubview(mNavBar, at: 1);
        
        createTab(systemNameImage: "house", imageSize: imageSize);
        createTab(systemNameImage: "magnifyingglass", imageSize: imageSize);
        createTab(systemNameImage: "person.fill", imageSize: imageSize);
        
        mNavBar.subviews[0].tintColor = UIColor(named: "AccentColor");
        
        mNavBar.center_vertical();
        mNavBar.center_horizontal();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        mDatabaseStats = mDatabase.reference(withPath: "Stats/iOS");
        
        isAuthUser = Auth.auth().currentUser != nil;
        
        modalPresentationStyle = .overFullScreen;
        
        let vc = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "techWorks") as! TechWorksViewController;
        
        history = userDefaults.array(forKey: StorageApp.historyKey) as? [UInt16] ?? [];
        likes = userDefaults.array(forKey: StorageApp.likesKey) as? [UInt16] ?? [];
        recommends = userDefaults.array(forKey: StorageApp.recommendsKey) as? [UInt16] ?? [];
        
        let ref = mDatabase.reference();
        
        let buildNumber = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "25") ?? 25;
        print(self.tag, "BUILD NUMBER:",buildNumber);
        
        let monitor = NWPathMonitor();
        monitor.pathUpdateHandler = {
            path in
            self.isConnected = path.status == .satisfied;
            if !self.isConnected {
                DispatchQueue.main.async {
                    self.heightSnackbar.constant = 24;
                    UIView.animate(withDuration: 0.23, animations: {
                        self.view.layoutIfNeeded();
                    });
                }
                return;
            }
            
            
            print("Manager", self.heightSnackbar.constant);
            DispatchQueue.main.async {
                self.heightSnackbar.constant = 0;
                
                // check server's state
                
                ref.child("opt")
                    .observeSingleEvent(of: .value,
                                        with: { snap in
                        if ((snap.childSnapshot(forPath: "state").value as? Int) == 0){
                            if (!vc.isViewLoaded){
                                self.navigationController?.pushViewController(vc, animated: true);
                            }
                            return;
                        }
                        
                        if ((snap.childSnapshot(forPath: "versi").value as? Int) ?? 25) > buildNumber {
                            Toast.init(text: "The new app version is available", duration: 3.5).show();
                            return;
                        }
                        
                        if !self.isAuthUser {
                            self.isLoadMetaData = true;
                            return;
                        }
                        
                        ref.child("Users/"+(self.userDefaults.string(forKey: Utils.userRef) ?? "null"))
                            .observeSingleEvent(of: .value,
                                                with: { userSnap in
                                if self.history.isEmpty{
                                    self.history = Crypt.decryptString(userSnap.childSnapshot(forPath: "his2").value as? String ?? "");
                                }
                                if self.likes.isEmpty{
                                    self.likes = Crypt.decryptString(userSnap.childSnapshot(forPath: "like2").value as? String ?? "");
                                }
                                if self.recommends.isEmpty{
                                    self.recommends = Crypt.decryptString(userSnap.childSnapshot(forPath: "rec2").value as? String ?? "");
                                }
                                self.isLoadMetaData = true;
                            })
                       
                    });
                UIView.animate(withDuration: 0.23, animations: {
                    self.view.layoutIfNeeded();
                });
            }
        }
        monitor.start(queue: DispatchQueue(label:"Network"));
        
     }
    
    
    private func blur() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial));
        blurView.alpha = 0.0;
        view.insertSubview(blurView, at: 2);
        blurView.frame = view.frame;
        trainingContainer.isHidden = false;
    }
    
    private func createTab(systemNameImage: String, imageSize: CGSize) {
        let iv = UIButton(frame: CGRect(origin: .zero, size: imageSize));
        
        let config = UIImage.SymbolConfiguration(pointSize: imageSize.height*0.42,
                                                 weight: .regular,
                                                 scale: .medium);
        iv.setImage(UIImage(systemName: systemNameImage, withConfiguration: config), for: .normal); // person.fill | house
        iv.tintColor = .lightGray;
        iv.backgroundColor = .clear;
        
        mNavBar.addTab(iv);
    }
}
