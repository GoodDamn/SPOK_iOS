//
//  ManagerViewController.swift
//  SPOK
//
//  Created by Cell on 26.06.2022.
//

import UIKit;
import Network;
import FirebaseDatabase;
import UserNotifications;

class ManagerViewController: UIViewController{
    
    private let tag = "ManagerViewController:";
    
    @IBOutlet weak var trainingContainer: UIView!;
    @IBOutlet weak var tabBarContainer: UIView!;
    @IBOutlet weak var pageContainer: UIView!;
    @IBOutlet weak var snackBarRating: UIView!;
    let language = Utils.getLanguageCode();
    //var inTopicRect:CGRect = CGRect();
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
    var freeTrialState: UInt8 = 0; // 0 - no free trial, 1 - is active, 2 - expired
    var isConnected: Bool = false;
    var isLoadMetaData: Bool = false;
    var pageViewController: MainPageViewController? = nil;
    var tabController: TabBarController? = nil;
    var ratingSnackBar: RatingSnackbar? = nil;
    var viewControllersPages:[UIViewController] = [];
    let userDefaults: UserDefaults = UserDefaults();
    
    @IBOutlet weak var heightSnackbar: NSLayoutConstraint!;
    @IBOutlet weak var heightSnackBarRating: NSLayoutConstraint!;
    @IBOutlet weak var bottomInset: NSLayoutConstraint!;
    
    private func blur() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial));
        blurView.alpha = 0.0;
        view.insertSubview(blurView, at: 2);
        blurView.frame = view.frame;
        trainingContainer.isHidden = false;
    }
    
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
                       id:Int,
                       startFrame:CGRect,
                       typeTopic:String = "Trainings/",
                       musicChild:String = "m",
                       contentChild:String = "text"+Utils.getLanguageCode(),
                       endOfSession:((Int)->Void)? = nil)->Void{
        
        var endOfTopic = endOfSession;
        
        if (endOfTopic == nil){
            endOfTopic = {
                id in
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
        
                        
        let name:String? = cell.nameTraining.text;
        print("startTraining", id, name)
        if cell.id == 0 || name == nil{
            return;
        }
        blur();
        
        if (id > 0){
            let uint16ID = UInt16(id);
            let indexExists = history.firstIndex(of: uint16ID);
            if indexExists != nil {
                history.remove(at: indexExists!);
            }
            history.append(uint16ID);
        }
        
        
        let controller = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "training") as! TopicActivity;
        controller.id = id;
        controller.view.frame = startFrame;
        controller.view.layer.masksToBounds = true;
        print("ManagerVC:", controller.view);
        controller.view.layer.cornerRadius = 17*1.15;
        controller.typeTopic = typeTopic;
        controller.musicChild = musicChild;
        controller.contentChild = contentChild;
        print("TopicActivity: ",controller.typeTopic, typeTopic)
        controller.endOfSession = endOfTopic;
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
        
        if segue.identifier == "tab"{
            tabController = segue.destination as? TabBarController;
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
        print(tag, "onPause()");
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = self.userDefaults.string(forKey: Utils.userRef);
            if userRef != nil && self.isConnected && self.isLoadMetaData{
                let dataRef = Database.database().reference(withPath: "Users/"+userRef!);
                dataRef.child("his2").setValue(Crypt.encryptString(self.history));
                dataRef.child("like2").setValue(Crypt.encryptString(self.likes));
                dataRef.child("rec2").setValue(Crypt.encryptString(self.recommends));
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.willResignActiveNotification, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        modalPresentationStyle = .overFullScreen;
        
        let vc = UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "techWorks") as! TechWorksViewController;
        
        history = userDefaults.array(forKey: StorageApp.historyKey) as? [UInt16] ?? [];
        likes = userDefaults.array(forKey: StorageApp.likesKey) as? [UInt16] ?? [];
        recommends = userDefaults.array(forKey: StorageApp.recommendsKey) as? [UInt16] ?? [];
        
        let ref = Database.database().reference();
        
        let monitor = NWPathMonitor();
        monitor.pathUpdateHandler = {
            path in
            self.isConnected = path.status == .satisfied;
            if self.isConnected {
                print("Manager", self.heightSnackbar.constant);
                DispatchQueue.main.async {
                    self.heightSnackbar.constant = 0;
                    ref.observeSingleEvent(of: .value, with: { [self]
                        snapshot in
                        if ((snapshot.childSnapshot(forPath: "state").value as? Int) == 0){
                            if (!vc.isViewLoaded){
                                self.navigationController?.pushViewController(vc, animated: true);
                            }
                        }
                        
                        let userSnap = snapshot.childSnapshot(forPath: "Users/"+(userDefaults.string(forKey: Utils.userRef) ?? "null"));
                        if history.isEmpty{
                            history = Crypt.decryptString(userSnap.childSnapshot(forPath: "his2").value as? String ?? "");
                        }
                        if likes.isEmpty{
                            likes = Crypt.decryptString(userSnap.childSnapshot(forPath: "like2").value as? String ?? "");
                        }
                        if recommends.isEmpty{
                            recommends = Crypt.decryptString(userSnap.childSnapshot(forPath: "rec2").value as? String ?? "");
                        }
                        self.isLoadMetaData = true;
                    });
                    UIView.animate(withDuration: 0.23, animations: {
                        self.view.layoutIfNeeded();
                    });
                }
                return;
            }
            
            DispatchQueue.main.async {
                self.heightSnackbar.constant = 24;
                UIView.animate(withDuration: 0.23, animations: {
                    self.view.layoutIfNeeded();
                });
            }
        }
        monitor.start(queue: DispatchQueue(label:"Network"));
        
     }
}
