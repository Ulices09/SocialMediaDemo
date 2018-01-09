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
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoSignIn()
    }

    func autoSignIn() {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "FeedViewController", sender: nil)
        }
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
    
    @IBAction func signInPressed(_ sender: UIButton) {
        print(usernameTextField.text)
        print(passwordTextField.text)
        
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty, password.count >= 6 {
            Auth.auth().signIn(withEmail: username, password: password, completion: { (user, error) in
                if error != nil {
                    Auth.auth().createUser(withEmail: username, password: password, completion: { (user, error) in
                        if error != nil {
                            print("LOGIN-LOG - Email Auth Error: \(error)")
                            self.alertMessage(title: "Error", message: "Cannot create account.")
                        } else {
                            print("LOGIN-LOG - Email Auth Success")
                            
                            if let user = user {
                                self.completeSignIn(uid: user.uid)
                            }
                        }
                    })
                } else {
                    print("LOGIN-LOG - Email Auth Success")
                    
                    if let user = user {
                        self.completeSignIn(uid: user.uid)
                    }
                }
            })
        } else {
            self.alertMessage(title: "Error", message: "Incorrect input data.")
        }
    }
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("LOGIN-LOG - Unable to sign in with firebase: \(error)")
            } else {
                print("LOGIN-LOG - Sucessful sign in with firebase")
                
                if let user = user {
                    self.completeSignIn(uid: user.uid)
                }
            }
        }
    }
    
    func completeSignIn(uid: String) {
        KeychainWrapper.standard.set(uid, forKey: KEY_UID)
        performSegue(withIdentifier: "FeedViewController", sender: nil)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successAlertMessage(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

