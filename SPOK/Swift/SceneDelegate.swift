//
//  SceneDelegate.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit;
import AuthenticationServices;
import FirebaseAuth;
//import FBSDKCoreKit;

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let tag = "SceneDelegate:";
    
    var window: UIWindow?;
    var scene: UIWindowScene?;
    
    func attachViewController(_ c:UIViewController){
        let window = UIWindow(windowScene: scene!);
        window.rootViewController = c;
        self.window = window;
        window.makeKeyAndVisible();
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        print(self, "Scene method");
        
        self.scene = scene as? UIWindowScene;
        if self.scene == nil {return;}
                
        let userDefaults = UserDefaults();
        
        let lastVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        print(tag,lastVersion);
        if let currentVersion = userDefaults.string(forKey: "version") {
            // Clear all cache if a new update
            
            print(tag, lastVersion, currentVersion);
            
            if currentVersion != lastVersion {
                
                do {
                    try? Auth.auth().signOut();
                } catch {
                    print(tag, "ERROR: WHILE SIGNING OUT IN THE NEW VERSION");
                }
                
                print(tag, "Clearing cache...");
                let fileManager = FileManager.default;
                
                let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first;
                
                do {
                    let dirContent = try fileManager.contentsOfDirectory(at: url!,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: []);
                    print(tag, "DIR_CONTENT:",dirContent);
                    for ff in dirContent {
                        do {
                            try fileManager.removeItem(at: ff);
                        } catch {
                            print(tag, "DELETING_FILE_ERROR:",error);
                        }
                        
                    }
                    
                } catch {
                    print(tag, "DELETE_CACHE_EXCEPTION:",error);
                }
                
                userDefaults.setValue(lastVersion, forKey: "version");
                print(tag, url);
                print(tag, "ATTACHING SignInViewController")
                self.attachViewController(UIStoryboard(name: "Main", bundle: Bundle.main)
                    .instantiateViewController(withIdentifier: "SignIn")
                    as! SignInViewController);
                return;
            }
            
        } else {
            userDefaults.setValue(lastVersion, forKey: "version");
        }
        
        if !userDefaults.bool(forKey: "intro") {
            print("Time for intro!")
            attachViewController(UIStoryboard(name: "intro", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "introNav")
                as! IntroNavigationController);
            return;
        }
        print("Intro is completed");
        let u = Auth.auth().currentUser;
        print(self,u);
        if u != nil {
            self.attachViewController(UIStoryboard(name: "mainMenu", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "mainNav")
                as! MainNavigationController);
            return;
        }
        self.attachViewController(UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "SignIn")
            as! SignInViewController);
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //guard let url = URLContexts.first?.url else {
        //    return
        //}

        /*ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )*/
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
