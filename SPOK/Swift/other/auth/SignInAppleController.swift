//
//  SignInAppleController.swift
//  SPOK
//
//  Created by GoodDamn on 02/02/2024.
//

import Foundation
import UIKit.UIView

class SignInAppleController
    : StackViewController {
    
    private static let TAG = "SignInAppleController"
    
    internal weak var mSignListener: SignInListener? = nil
    
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
    
    func onError(
        _ msg: String
    ) {
        print("ERROR_SIGN_IN:", msg)
        mSignListener?.onErrorSign(msg)
    }
    
    func onSuccess(
        token: String,
        nonce: String,
        authCode: String
    ) {
        mSignListener?.onSuccessSign(
            token: token,
            nonce: nonce,
            authCode: authCode
        )
        
    }
    
}
