//
//  ViewController.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit;
import AuthenticationServices;
import FirebaseCore;
import FirebaseAuth;
import CryptoKit;
//import FBSDKLoginKit;

class SignInViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    @IBOutlet weak var b_apple: UIButton!;
    @IBOutlet weak var b_facebook: UIButton!;
    @IBOutlet weak var l_privacy: UITextView!;
    
    fileprivate var currentNonce: String?;
    var signInWithApple: SignInWithAppleDelegate? = nil;
    
    private var shapes:[UIView]!;
    var paths:[UIBezierPath]!;
    private var s:CGFloat = 50;
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    
    public static func randomNonceString(length: Int = 32) -> String{
        precondition(length > 0);
        let charset : [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._");
        var result = "";
        var remainingLength = length;
        while remainingLength > 0{
            let randoms: [UInt8] = (0 ..< 16).map{
                _ in
                var random: UInt8 = 0;
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random);
                if errorCode != errSecSuccess{
                    fatalError("Unable to generate nonce");
                }
                return random;
            }
            
            randoms.forEach{
                random in
                if remainingLength == 0{
                    return;
                }
                
                if random < charset.count{
                    result.append(charset[Int(random)]);
                    remainingLength -= 1;
                }
            }
        }
        return result;
    }
    
    public static func sha256(_ input:String)->String{
        return SHA256.hash(data: Data(input.utf8)).compactMap({
            String(format: "%02x", $0);
        }).joined();
    }
    
    private class Shape:CAShapeLayer{
        public var isReversed:Bool = false;
    }
    
    private func drawLine(move:CGPoint,x:CGFloat, y:CGFloat, path:UIBezierPath)->Void{
        path.move(to: move);
        path.addLine(to: CGPoint(x:x,y: y));
    }
    
    private func configShape(path:UIBezierPath, layer:Shape)->Void{
        layer.path = path.cgPath;
        layer.strokeColor = UIColor(named: "shape")!.cgColor;
        layer.lineCap = .round;
        layer.lineJoin = .round;
        layer.lineWidth = 4.9;
    }
    
    private func belongs(x:CGFloat, y:CGFloat, x1:CGFloat, y1:CGFloat, size:CGFloat)->Bool{
        return (x <= x1 && x1 <= (x+size))&&(y <= y1 && y1 <= (y+size));
    }
    
    private func generatePosition(view:UIView,wid:CGFloat, hei:CGFloat)->Void{
        let w = CGFloat.random(in: 0...wid),
            h = CGFloat.random(in: 0...hei);
        
        var isBelongs = false;
        
        for i in 0..<shapes.count{
            let x = self.shapes[i].frame.origin.x,
                y = self.shapes[i].frame.origin.y;
            
            if (belongs(x: x, y: y, x1: w, y1: h, size: s) ||
                belongs(x: x, y: y, x1: w+s, y1: h, size: s) ||
                belongs(x: x, y: y, x1: w, y1: h+s, size: s) ||
                belongs(x: x, y: y, x1: w+s, y1: h+s, size: s))
            {
                isBelongs = true;
                break;
            }
        }
        
        if (isBelongs){
            generatePosition(view: view, wid: wid, hei: hei);
        } else {
            view.layer.frame.origin.x = w;
            view.layer.frame.origin.y = h;
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //s = 35 * UIScreen.main.scale; // For shape's size
        b_facebook.layer.cornerRadius = b_facebook.bounds.height/2;
        b_facebook.imageView?.contentMode = .scaleAspectFit;
        b_facebook.imageEdgeInsets = UIEdgeInsets(top: 0,left: -20, bottom: 0, right: 0);
        Utils.Design.roundedButton(b_apple);
        //b_apple.imageView?.contentMode = .scaleAspectFit;
        b_apple.imageEdgeInsets = UIEdgeInsets(top: 0, left:-20, bottom: 0, right: 0);
    
        l_privacy.text = NSLocalizedString("byCon", tableName: "Localization", bundle: Bundle.main, value: "", comment: "");
        print("SignIn", l_privacy.text);
        Utils.setPrivacyAndTerms(tv_terms: l_privacy, textColour: UIColor(named: "privacy_color")!);
        
        let rectPath = UIBezierPath();
        drawLine(move:CGPoint(x: 12.5, y: 12.5),x: 37.5, y: 12.5,path: rectPath);
        drawLine(move:CGPoint(x: 37.5, y: 12.5),x: 37.5, y: 37.5, path: rectPath);
        drawLine(move:CGPoint(x: 37.5, y: 37.5),x: 12.5, y: 37.5, path: rectPath);
        drawLine(move:CGPoint(x: 12.5, y: 37.5),x: 12.5, y: 12.5, path: rectPath);
        
        let polyPath = UIBezierPath();
        drawLine(move: CGPoint(x: 5.5, y: 37.5), x: 37.5, y: 37.5, path: polyPath);
        drawLine(move: CGPoint(x: 37.5, y: 37.5), x: 25, y: 12.5, path: polyPath);
        drawLine(move: CGPoint(x: 25, y: 12.5), x: 5.5, y: 37.5, path: polyPath);
        
        let crossPath = UIBezierPath();
        drawLine(move: CGPoint(x: 12.5, y: 12.5), x: 37.5, y: 37.5, path: crossPath);
        drawLine(move: CGPoint(x: 12.5, y: 37.5), x: 37.5, y: 12.5, path: crossPath);
        
        paths = [UIBezierPath]();
        paths.append(crossPath);
        paths.append(polyPath);
        paths.append(rectPath);
        
        shapes = [UIView]();
        
        let startAnimation = CABasicAnimation(keyPath: "strokeEnd");
        startAnimation.fromValue = 1.0;
        startAnimation.toValue = 0.0;
        startAnimation.duration = CFTimeInterval(CGFloat.random(in: 3.5...8.0));
        
        let widthScreen = UIScreen.main.bounds.width-20,
            heightScreen = UIScreen.main.bounds.height-20;
        
        for _ in 0..<40{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: s, height: s));
            let layer = Shape();
            configShape(path: paths[Int.random(in: 0..<3)], layer: layer);

            view.layer.addSublayer(layer);
            self.view.addSubview(view);
            self.view.sendSubviewToBack(view);
            generatePosition(view: view, wid: widthScreen, hei: heightScreen);
            
            view.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0...360));
            
            shapes.append(view);

        }
        
        let btnClose = UIButton(frame: CGRect(x: widthScreen-50, // 70 = 20(offset) + 50(width)
                                              y: 20,
                                              width: 50,
                                              height: 50));
        
        btnClose.tintColor = UIColor(named: "close");
        
        btnClose.setImage(UIImage(systemName: "xmark",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                          for: .normal);
        btnClose.addTarget(self,
                           action: #selector(closeScreen(_:)),
                           for: .touchUpInside);
        view.addSubview(btnClose);
        
    }
    
    @objc func closeScreen(_ v: UIButton) {
        Utils.moveToAnotherViewController(
            UIStoryboard(name: "mainMenu", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "mainNav")
                as! MainNavigationController,
            animation: .transitionCurlUp);
    }
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        
    }
    
    @IBAction func loginApple(_ sender: UIButton) {
        print("Apple auth is started");
        
        signInWithApple = SignInWithAppleDelegate();
        signInWithApple?.run(presentation: self, controllerDelegate: self);
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInWithApple?.errorSignIn(didCompleteWithError: error);
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        signInWithApple?.completeSignIn(didCompleteWithAuthorization: authorization, errorTrig: nil, completionSignIn: {
            Utils.moveToAnotherViewController(
                UIStoryboard(name: "mainMenu", bundle: Bundle.main)
                    .instantiateViewController(withIdentifier: "mainNav")
                    as! MainNavigationController,
                animation: .transitionCurlUp);
            // Local notification test
            Utils.configNotifications();
            //window.rootViewController = v;
        });
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view!.window!;
    }
}
