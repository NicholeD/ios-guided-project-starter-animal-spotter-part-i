//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
            signInButton.tintColor = .white
            signInButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType
        if let username = usernameTextField.text,
            // if the username is not empty:
            !username.isEmpty,
            let password = passwordTextField.text,
            //if the password is not empty:
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                apiController?.signUp(with: user, completion: { error in
                    //what do we do when the signup is complete - with no error state
                    if let error = error {
                        NSLog("error occurred during sign up: \(error)")
                    } else {
                        // no error means we successed - now let's tell the user
                        // sync back to the main queue
                        DispatchQueue.main.async {
                            // pop window that the user sees with OK button
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                            // alert action dismisses view automatically - no need to put the dismiss code in
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true) {
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                            }
                        }
                    }
                })
            }else {
                // user wants to sign in
                apiController?.signIn(with: user, completion: { error in
                    if let error = error {
                        NSLog("Error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between login types
        if sender.selectedSegmentIndex == 0 {
            // this is sign up
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            // this is sign in
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
