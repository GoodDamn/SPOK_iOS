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
    
    internal var mSignListener: SignInListener? = nil
    
    private let mSignIn = SignInApple()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mSignIn.mListener = self
    }
    
    internal func signIn() {
        mSignIn.start()
    }
    
}

extension SignInAppleController
    : SignInAppleListener {
    
    func onAnchor() -> UIView {
        return view
    }
    
    func onError(
        _ msg: String
    ) {
        print("ERROR_SIGN_IN:", msg)
        mSignListener?.onErrorSign(msg)
    }
    
    func onSuccess(
        credentials: AuthCredential
    ) {
        
        mSignListener?.onSuccessSign(
            credentials: credentials
        )
        
    }
    
}
