//
//  SignInWithAppleDelegate.swift
//  SPOK
//
//  Created by Cell on 27.10.2022.
//

import AuthenticationServices;
import FirebaseAuth

class SignInApple
    : NSObject,
      ASAuthorizationControllerDelegate,
      ASAuthorizationControllerPresentationContextProviding {
    
    private var mNonce = "";
    
    weak var mListener: SignInAppleListener? = nil
        
    func start() {
        
        mNonce = Crypt
            .randomNonce()
        
        let request = ASAuthorizationAppleIDProvider()
            .createRequest()
        
        request.requestedScopes = [
            .fullName,
            .email
        ]
        
        request.nonce = Crypt
            .sha256(
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
        
        case let appleID as ASAuthorizationAppleIDCredential:
            let idApple = appleID.user;
            let fullName = appleID.fullName;
            
            print( ": Apple ID credentials: ", idApple, fullName);
            
            let userDef = UserDefaults
                .standard;
            
            let token = String(
                data: appleID.identityToken!,
                encoding: .utf8
            )!
            
            userDef.setValue(
                fullName?.givenName,
                forKey: Keys.GIVEN_NAME
            )
            
            let cred = OAuthProvider
                .credential(
                    withProviderID: "apple.com",
                    idToken: token,
                    rawNonce: mNonce
                )
            
            mListener?.onSuccess(
                credentials: cred,
                def: userDef
            )
            
        default:
            break
        }

        
    }
    
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        
        return mListener?
            .onAnchor()
            .window
        
        ?? ASPresentationAnchor
            .init(
                frame: .zero
            )
    }
}
