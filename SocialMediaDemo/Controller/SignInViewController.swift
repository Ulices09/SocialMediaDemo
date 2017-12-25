//
//  ViewController.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 24/12/17.
//  Copyright © 2017 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginWithFacebookPressed(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.loginBehavior = .web
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("LOGIN-LOG - Facebook sign in Error: \(error)")
            case .cancelled:
                print("LOGIN-LOG - User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("LOGIN-LOG - Logged in!")                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("LOGIN-LOG - Unable to sign in with firebase: \(error)")
            } else {
                print("LOGIN-LOG - Sucessful sign in with firebase")
            }
        }
    }
    
}

