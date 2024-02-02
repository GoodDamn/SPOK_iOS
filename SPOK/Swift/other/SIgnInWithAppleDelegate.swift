//
//  SIgnInWithAppleDelegate.swift
//  SPOK
//
//  Created by Cell on 27.10.2022.
//

import AuthenticationServices;
import FirebaseCore;
import FirebaseAuth;

class SignInWithAppleDelegate
    : NSObject,
      ASAuthorizationControllerDelegate,
      ASAuthorizationControllerPresentationContextProviding {
    
    private var mNonce:String = "";
    
        
    func run() {
        
        mNonce = Crypt.randomNonce()
        
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
                forKey: Utils.givenName
            )
            
            let auth = Auth.auth();
            
            let cred = OAuthProvider
                .credential(
                    withProviderID: "apple.com",
                    idToken: token,
                    rawNonce: mNonce
            )
            
            
            auth.signIn(
                with: cred
            ) { (authResult, error) in
                if error != nil{
                    print(error);
                    return;
                }
                
                if let id = auth.currentUser?.uid
                {
                    userDef.setValue(
                        id,
                        forKey: Utils.userRef
                    )
                    
                }
            }
            
        default:
            break
        }

        
    }
    
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        return view.window!
    }
}
