//
//  ViewController.swift
//  SPOK
//
//  Created by Cell on 10.12.2021.
//

import UIKit
import FirebaseAuth

class SignInViewController
    : StackViewController,
      SignInAppleListener  {
    
    private var mBtnApple: UIButton!
    private var mTextViewPrivacy: UITextView!
    
    private let mSignInApple = SignInApple()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Creating components
        // Loading resources
        // Delegates, colors, font and etc.
        
        mSignInApple.mListener = self
        
        let bgColor = UIColor(
            named: "background"
        )
        
        let bold = UIFont(
            name: "OpenSans-Bold",
            size: 1
        )
        
        let w = view.frame.width
        let h = view.frame.height
        
        let wbtnSignApple = 0.922 * w
        let marginLeft = (w - wbtnSignApple) / 2
        let hbtnSignApple = 0.128 * w
        
        // Creating views
        // Calculating bounds
        mBtnApple = UIButton(
            frame: CGRect(
                x: marginLeft,
                y: h * 0.45,
                width: wbtnSignApple,
                height: hbtnSignApple
            )
        )
        
        mTextViewPrivacy = UITextView(
            frame: CGRect(
                x: marginLeft,
                y: mBtnApple.frame.bottom(),
                width: wbtnSignApple,
                height: 1
            )
        )
        
        // Fonts
        mBtnApple
            .titleLabel?
            .font = bold?.withSize(
                0.32 * hbtnSignApple
            )
        
        
        // Colors
        mBtnApple.setTitleColor(
            .white,
            for: .normal
        )
        mBtnApple.backgroundColor = bgColor
        mBtnApple
            .layer
            .shadowColor = UIColor
                .white.cgColor
        
        view.backgroundColor = bgColor
        
        // Strings
        mBtnApple.setTitle(
            "Войти с помощью Apple",
            for: .normal
        )
        
        // Some design
        let bl = mBtnApple.layer
        bl.cornerRadius = 0.5 * hbtnSignApple
        bl.shadowOffset = CGSize(
            width: 0.5,
            height: 0.5
        )
        bl.shadowRadius = hbtnSignApple * 0.17
        bl.shadowOpacity = 0.55
        
        mBtnApple.addTarget(
            self,
            action: #selector(
                signInApple(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(
            mBtnApple
        )
    }
    
    @objc private func signInApple(
        _ sender: UIButton
    ) {
        print("Apple auth is started");
        mSignInApple.start()
    }
    
    func onAnchor() -> UIView {
        return view
    }
    
    func onError(
        _ msg: String
    ) {
        print("ERROR_SIGN_IN:", msg)
    }
    
    func onSuccess(
        token: String,
        nonce: String,
        def: UserDefaults
    ) {
        
        let cred = OAuthProvider
            .credential(
                withProviderID: "apple.com",
                idToken: token,
                rawNonce: nonce
            )
        
        Auth.auth().signIn(
            with: cred
        ) { (authResult, error) in
            
            if error != nil {
                print(error);
                return;
            }
            
            guard let id = authResult?.user
                .uid else {
                return
            }
            
            def.setValue(
                id,
                forKey: Keys.USER_REF
            )
            
        }
    }
    
    
}


