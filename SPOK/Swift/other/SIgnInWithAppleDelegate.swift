//
//  SIgnInWithAppleDelegate.swift
//  SPOK
//
//  Created by Cell on 27.10.2022.
//

import AuthenticationServices;
import FirebaseAuth;

class SignInWithAppleDelegate{
    
    //var view:UIView? = nil;
    //var completionSignedIn: (()->Void)? = nil;
    //var signInError: (()->Void)? = nil;
    
    var nonce:String = "";
    
    /*init(view:UIView, completionSignedIn: @escaping (()->Void), singError: (()->Void)?){
        self.view = view;
        self.completionSignedIn = completionSignedIn;
        self.signInError = singError;
    }*/
    
    func run(presentation: ASAuthorizationControllerPresentationContextProviding, controllerDelegate: ASAuthorizationControllerDelegate){
        print(self, "Apple auth")
        nonce = SignInViewController.randomNonceString();
        
        let request = ASAuthorizationAppleIDProvider().createRequest();
        request.requestedScopes = [.fullName, .email];
        request.nonce = SignInViewController.sha256(nonce);
        let authController = ASAuthorizationController(authorizationRequests: [request]);
        authController.delegate = controllerDelegate;
        authController.presentationContextProvider = presentation;
        authController.performRequests();
    }
    
    func errorSignIn(didCompleteWithError error: Error)->Void{
        print("Apple auth error:", error);
    }
    
    func completeSignIn(didCompleteWithAuthorization authorization: ASAuthorization, errorTrig: (()->Void)?, completionSignIn: @escaping (()->Void)) -> Void {
        print(self, authorization.credential);
        switch authorization.credential {
        case let appleID as ASAuthorizationAppleIDCredential:
            let idApple = appleID.user;
            let fullName = appleID.fullName;
            print(self, ": Apple ID credentials: ", idApple, fullName);
            let userDef = UserDefaults();
            let token = String(data: appleID.identityToken!, encoding: .utf8)!;
            userDef.setValue(fullName?.givenName, forKey: Utils.givenName);
            
            let auth = Auth.auth();
            auth.signIn(with: OAuthProvider.credential(withProviderID: "apple.com", idToken: token, rawNonce: nonce), completion: {
                (authResult, error) in
                if error != nil{
                    print(self, error);
                    errorTrig?();
                    return;
                }
                
                if let id = auth.currentUser?.uid{
                    userDef.setValue(id, forKey: Utils.userRef);
                    completionSignIn();
                }
            });
            
        default:
            break
        }
    }
}
