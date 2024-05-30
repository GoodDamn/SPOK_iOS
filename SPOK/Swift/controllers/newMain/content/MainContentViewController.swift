//
//  ManagerViewController.swift
//  SPOK
//
//  Created by Cell on 26.06.2022.
//

import UIKit;
import FirebaseDatabase;

class MainContentViewController
    : StackViewController {
    
    private let TAG = "MainContentViewController:";
    
    private let mDatabase = Database
        .database()
    
    private var mNavBar: BottomNavigationBar!;
    
    private var mPageView: SimplePageViewController? = nil;
        
    override func onTransitionEnd() {
        NotificationUtils
            .request()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.d(TAG, "viewDidLoad()")
        
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
            named: "AccentColor"
        );
        
        mNavBar.mOnSelectTab = { index in
            self.mPageView?
                .mIndex = index
        }
        
        createTab(systemNameImage: "house", imageSize: imageSize);
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
        
        mPageView = SimplePageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        mPageView?.source = [
            HomeViewController(),
            AppDelegate.mDoAppleCheck
                ? SettingsViewController()
                : ProfileNewViewController()
        ]
        
        addChild(
            mPageView!
        )
        
        let cont = mPageView!.view!
        
        view.addSubview(
            cont
        )
        
        view.addSubview(mNavBar);
        
        checkPopupNews()

    }
    
    override func viewDidLayoutSubviews() {
        Log.d("MainContentViewController", "viewDidLayout:")
        mPageView?.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height - mNavBar.frame.height
        )
        
        super.viewDidLayoutSubviews()
    }
    
    override func onUpdatePremium() {
        Log.d(
            TAG,
            "onUpdatePremium:",
            MainViewController.mIsPremiumUser,
            mPageView
        )
        
        if mPageView == nil {
            return
        }
        
        for i in mPageView!.source {
            (i as? StackViewController)?
                .onUpdatePremium()
        }
        
    }
    
}

extension MainContentViewController {
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
        )
        iv.tintColor = .lightGray;
        iv.backgroundColor = .clear;
        
        mNavBar.addTab(iv);
    }
    
    
    private func checkPopupNews() {
        let def = UserDefaults.standard
        let lastId = def.integer(
            forKey: Keys.ID_NEWS
        )
        
        let currentId = lastId + 1
        
        let buildNumber = MainViewController
            .mBuildNumber
        
        let ref = mDatabase
            .reference(
                withPath: "NEWS_NOTIFY/i/\(buildNumber)/\(currentId)"
            )
        
        ref.observeSingleEvent(
            of: .value
        ) { [weak self] snap in
            self?.checkNews(
                snap,
                currentId: currentId
            )
        }
        
    }
    
    private func checkNews(
        _ snap: DataSnapshot,
        currentId: Int
    ) {
        let title = snap.childSnapshot(
            forPath: "t"
        ).value as? String
        
        guard let desc = snap.childSnapshot(
            forPath: "d"
        ).value as? String else {
            return
        }
        
        let type = snap.childSnapshot(
            forPath: "i"
        ).value as? Int ?? 0
        
        let popup = PopupNewsViewController()
        popup.title = title
        popup.msgType = type
        popup.msgDescription = desc
        popup.msgID = currentId
        popup.view.alpha = 0
        push(
            popup,
            animDuration: 0.4
        ) {
            popup.view.alpha = 1
        }
    }
}
