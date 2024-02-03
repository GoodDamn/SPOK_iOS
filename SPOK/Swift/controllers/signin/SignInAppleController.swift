//
//  SignInAppleController.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import UIKit.UIView
import FirebaseAuth

class SignInAppleController
    : StackViewController {
    
    private static let TAG = "SignInAppleController"
    
    var onSigned: (()->Void)? = nil
    
    private let mSignIn = SignInApple()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mSignIn.mListener = self
    }
    
    internal func signIn() {
        mSignIn.start()
    }
    
    internal func onSignError() {}
    internal func onSignSuccess() {}
}

extension SignInAppleController
    : SignInAppleListener {
    
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
        onSignError()
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
                print(
                    SignInAppleController
                        .TAG,
                    "ERROR:",
                    error
                )
                return
            }
            
            def.setValue(
                auth.user.uid,
                forKey: Keys.USER_REF
            )
            
            s.onSignSuccess()
            s.onSigned?()
        }
    }
    
}
