//
//  SignInWithAppleDelegate.swift
//  SPOK
//
//  Created by Cell on 27.10.2022.
//

import AuthenticationServices

class SignInApple
    : NSObject,
      ASAuthorizationControllerDelegate,
      ASAuthorizationControllerPresentationContextProviding {
    
    private var mNonce = "";
    
    weak var mListener: SignInAppleListener? = nil
        
    func start() {
        
        mNonce = SKUtilsCrypt.randomNonce()
        
        let request = ASAuthorizationAppleIDProvider()
            .createRequest()
        
        request.requestedScopes = [
            .fullName,
            .email
        ]
        
        request.nonce = SKUtilsCrypt.sha256(
            mNonce
        )
        
        let authController = ASAuthorizationController(
            authorizationRequests: [
                request
            ]
        )
        authController.delegate = self
        
        authController
            .presentationContextProvider = self
        
        authController.performRequests()
    }
    
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        mListener?.onError(
            error.localizedDescription
        )
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        
        switch authorization.credential {
        
        case let appleId as ASAuthorizationAppleIDCredential:
            
            guard let token = String(
                data: appleId.identityToken!,
                encoding: .utf8
            ) else {
                return
            }
            
            guard let authCode = appleId.authorizationCode else {
                return
            }
            
            guard let authCodeStr = String(
                data: authCode,
                encoding: .utf8
            ) else {
                return
            }
            
            
            mListener?.onSuccess(
                token: token,
                nonce: mNonce,
                authCode: authCodeStr
            )
            
        default:
            break
        }

        
    }
    
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        UIApplication
            .main()
            .view
            .window!
    }
}
