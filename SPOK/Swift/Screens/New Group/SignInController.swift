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
    
    private let TAG = "SignInViewController:"
    
    var onSigned: (() -> Void)? = nil
    
    private var mBtnApple: UIButton!
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
        
        let btnClose = ViewUtils
            .buttonClose(
                in: view,
                sizeSquare: 0.08
            )
        
        let mTextViewPrivacy = UITextView(
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
        mBtnApple.tintColor = .white
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
        
        btnClose.alpha = 0.11
        
        mBtnApple.setImage(
            UIImage(
                systemName: "applelogo"
            ),
            for: .normal
        )
        
        mBtnApple.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -10,
            bottom: 0,
            right: 10
        )
        
        // Adding targets
        
        mBtnApple.addTarget(
            self,
            action: #selector(
                signInApple(_:)
            ),
            for: .touchUpInside
        )
        
        btnClose.addTarget(
            self,
            action: #selector(
                onClickBtnClose(_:)
            ),
            for: .touchUpInside
        )
        
        // Adding views
        
        view.addSubview(
            mBtnApple
        )
        
        view.addSubview(
            btnClose
        )
    }
    
    @objc override func onClickBtnClose(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        onSigned?()
    }
    
    @objc private func signInApple(
        _ sender: UIButton
    ) {
        sender.isEnabled = false
        print("Apple auth is started");
        mSignInApple.start()
    }
    
    func onAnchor() -> UIView {
        return view
    }
    
    func onError(
        _ msg: String
    ) {
        Toast.init(
            text: msg,
            duration: 2.5
        ).show()
        
        print("ERROR_SIGN_IN:", msg)
        mBtnApple.isEnabled = true
    }
    
    func onSuccess(
        credentials: AuthCredential,
        def: UserDefaults
    ) {
        Auth.auth().signIn(
            with: credentials
        ) { [weak self] (authResult, error) in
            
            guard let s = self else {
                print("SignInController: onSuccess: GC")
                return
            }
            
            guard let auth = authResult,
                  error == nil else {
                print(s.TAG,"ERROR:",error)
                return
            }
            
            def.setValue(
                auth.user.uid,
                forKey: Keys.USER_REF
            )
            
            s.onSigned?()
            
        }
    }
    
    
}


