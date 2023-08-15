//
//  SettingsViewController.swift
//  SPOK
//
//  Created by Cell on 25.12.2021.
//

import UIKit;
import FirebaseAuth;
import FirebaseDatabase;
import AuthenticationServices;
//import FBSDKLoginKit;
import MessageUI;

class SettingsVController:UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    struct Option{
        var img:UIImage?;
        var text: String;
        var color: UIColor?;
        var isHiddenArrow: Bool = false;
        var clickHandler:(()->Void);
    }
    
    private var options: [Option]!;
    
    @IBOutlet weak var tableView_options: UITableView!;
    @IBOutlet weak var switcherNotification: UISwitch!;
    @IBOutlet weak var mBtnDeleteAcc: UIButton!;
    
    var signInWithApple: SignInWithAppleDelegate? = nil;
    private let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current();
    
    @IBAction func switchDidChange(_ sender: UISwitch){
        if sender.isOn{
            Utils.configNotifications(center: notificationCenter);
            return;
        }
        
        notificationCenter.removeAllPendingNotificationRequests();
    }
    
    @IBAction func deleteAccount(_ sender: UIButton){
        showAlertDialog(title: sender.titleLabel?.text ?? "", message: Utils.getLocalizedString("delAcc"), preferredStyle: .alert, actions: {
            alertDialog in
            alertDialog.addAction(UIAlertAction(title: Utils.getLocalizedString("yes"), style: .default, handler: {_ in
                self.signInWithApple = SignInWithAppleDelegate();
                self.signInWithApple?.run(presentation: self, controllerDelegate: self);
            }));
            alertDialog.addAction(UIAlertAction(title: Utils.getLocalizedString("cancel"), style: .cancel, handler: nil));
        });
    }
    
    private func moveToSignIn(withDeletingData:Bool = true)->Void{
        let userDef = UserDefaults();
        userDef.removeObject(forKey: Utils.userRef);
        userDef.removeObject(forKey: Utils.givenName);
        
        if (withDeletingData) {
            userDef.removeObject(forKey: StorageApp.likesKey);
            userDef.removeObject(forKey: StorageApp.historyKey);
            userDef.removeObject(forKey: StorageApp.recommendsKey);
        }
        Utils.moveToAnotherViewController(UIStoryboard(name: "Main", bundle: nil) .instantiateViewController  (withIdentifier: "SignIn") as!  SignInViewController, animation: .transitionCurlDown);
    }
    
    
    private func showAlertDialog(title:String, message:String?, preferredStyle: UIAlertController.Style,actions: ((UIAlertController)->Void)?) -> Void{
        let alertDialog = UIAlertController(title: title, message: message, preferredStyle: preferredStyle);
        actions?(alertDialog);
        self.present(alertDialog, animated: true, completion: nil);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        /*let _promoCodes = Option(img: UIImage(systemName: "tag.fill"), text: Constants.getLocalizedString("promoCodes"), clickHandler: {
            self.navigationController?.pushViewController(UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "promoCodes"), animated: true);
        });*/
        
        
        let _SignIn = Option(
            img: UIImage(systemName: "applelogo"),
            text: Utils.getLocalizedString("signApple"),
            isHiddenArrow: true,
            clickHandler: {
                self.moveToSignIn(withDeletingData: false);
            });
        
        let _aboutApp = Option(
            img: UIImage(systemName: "info.circle.fill"),
            text: Utils.getLocalizedString("aboutApp"),
            clickHandler: {
                self.navigationController?.pushViewController(UIStoryboard(name: "mainMenu", bundle: nil).instantiateViewController(withIdentifier: "aboutApp"), animated: true);
            });
        
        let _rateUs = Option(
            img: UIImage(systemName: "star.fill"),
            text: Utils.getLocalizedString("rateUs"),
            clickHandler: {
                self.navigationController?
                    .pushViewController(UIStoryboard(name: "mainMenu", bundle: nil)
                        .instantiateViewController(withIdentifier: "rateUs"), animated: true);
            });
        
        let _contactUs = Option(
            img: UIImage(systemName: "text.bubble.fill"),
            text: Utils.getLocalizedString("contactUs"),
            isHiddenArrow: true,
            clickHandler: {
                guard MFMailComposeViewController.canSendMail() else{
                    self.showAlertDialog(title: "Contact us", message: "You can't send mail now, please try again later", preferredStyle: .alert, actions: {
                        alert in
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
                    });
                    return;
                };
                
                let composer:MFMailComposeViewController = MFMailComposeViewController();
                
                composer.mailComposeDelegate = self;
                composer.setToRecipients(["spok.app.community@gmail.com"]);
                composer.setSubject("Review");
                self.present(composer, animated: true, completion: nil);
        });
        
        let _logOut = Option(img: UIImage(named:"logOut"), text: Utils.getLocalizedString("logOut"), color: UIColor(red: 1.0, green: 0.35, blue: 0.254, alpha: 1.0), isHiddenArrow: true, clickHandler: {
            do {
                try Auth.auth().signOut();
                self.moveToSignIn();
            } catch{
                print("Settings: ", "Sign out with error: ", error);
            }
        });
                
        notificationCenter.getPendingNotificationRequests(completionHandler: {
            requests in
            DispatchQueue.main.async {
                self.switcherNotification.setOn(!requests.isEmpty, animated: true);
            }
        });
        
        let navBar = navigationController?.navigationBar;
        navBar?.barTintColor = UIColor(named: "background");
        navBar?.setBackgroundImage(UIImage(), for: .default);
        navBar?.shadowImage = UIImage();
        navBar?.isTranslucent = true;
        title = Utils.getLocalizedString("settings");
        navigationController?.view.backgroundColor = .clear;
        Utils.Design.barButton(navigationController, Utils.getLocalizedString("profile"));
        
        if (Auth.auth().currentUser == nil) {
            options = [_aboutApp,
                _SignIn];
            mBtnDeleteAcc.isHidden = true;
            mBtnDeleteAcc.isEnabled = false;
        } else {
            options = [_aboutApp,
                _rateUs,
                _contactUs,
                _logOut];
        }
        
        tableView_options.delegate = self;
        tableView_options.dataSource = self;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .semibold)];
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent != nil{
            return;
        }
        
        guard let manager = Utils.getManager() else {
            return;
        }
        
        manager.bottomInset.constant = 49;
        UIView.animate(withDuration: 0.25, animations: {
            manager.view.layoutIfNeeded();
            manager.mNavBar.frame.origin.y = UIScreen.main.bounds.height - manager.mNavBar.frame.size.height;
        }, completion: {
            b in
            manager.mNavBar.isUserInteractionEnabled = true;
        });
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInWithApple?.errorSignIn(didCompleteWithError: error);
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        signInWithApple?.completeSignIn(didCompleteWithAuthorization: authorization, errorTrig: {
            self.showAlertDialog(title: "Error", message: Utils.getLocalizedString("errAuth"),preferredStyle: .alert, actions: {alert in alert.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))});
        }, completionSignIn: {
            
            if let userID = Utils.getManager()?.userDefaults.string(forKey: Utils.userRef){
                Database.database().reference(withPath: "Users/"+userID).removeValue();
                Auth.auth().currentUser?.delete(completion: {
                    error in
                    if let error = error{
                        self.showAlertDialog(title: Utils.getLocalizedString("actionUna"), message: Utils.getLocalizedString("cannotDelAcc"), preferredStyle: .alert, actions: {
                            alert in
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
                        });
                        print("Delete an account: Error: ", error);
                        return;
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                        self.moveToSignIn();
                    });
                    
                    self.showAlertDialog(title: Utils.getLocalizedString("success"), message: Utils.getLocalizedString("delAccSuc"), preferredStyle: .alert, actions:nil);
                });
            }
        });
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view!.window!;
    }
}

extension SettingsVController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        options[indexPath.row].clickHandler();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath) as! SettingsTableViewCell;
        
        let op = options[indexPath.row];
        
        cell.icon.image = op.img;
        cell.arrow.isHidden = op.isHiddenArrow;
        cell.label.text = op.text;
        
        if (op.color != nil){
            cell.label.textColor = op.color;
        }
        
        return cell;
    }
    
}

extension SettingsVController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            controller.dismiss(animated: true, completion: nil);
            return;
        }
        
        if (result == .sent){
            Toast.init(text: Utils.getLocalizedString("thankYou"), duration: 1).show();
        }
        
        controller.dismiss(animated: true, completion: nil);
    }
}
