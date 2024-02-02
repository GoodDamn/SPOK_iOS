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
    
    override func loadView() {
        super.loadView()
        
        mBtnApple = UIButton()
        mBtnApple.setTitle(
            "",
            for: .normal
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        mSignInApple.mListener = self
        
    }
    
    @objc private func closeScreen(
        _ v: UIButton
    ) {

    }
    
    
    @objc private func loginApple(
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
                forKey: Utils.userRef
            )
            
        }
    }
    
    
}


