//
//  RegisterController.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

//
//  ViewController.swift
//  InterstellarBattalion
//
//  Created by Aaron Nebbs on 04/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class RegisterController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
    @IBOutlet weak var rocketLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the fields so they are underlined.
        emailField.underlined()
        passwordField.underlined()
        passwordAgainField.underlined()
    }
    
    // Called when register account is clicked.
    @IBAction func registerAccount(){
        let email: String = emailField.text!
        let password: String = passwordField.text!
        let passwordAgain: String = passwordAgainField.text!
        
        /*
         Check if user has entered passwords the same
         and check if email address is not null. Then
         attempt a login.
         */
        if(password == passwordAgain){
            if(email != ""){
                rocketLogo.startRotating()
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil{
                        print("UserHandler -> failed to create user account")
                        self.rocketLogo.stopRotating()
                        self.emailField.shake()
                        self.passwordField.shake()
                        self.passwordAgainField.shake()
                    }else{
                        print("UserHandler -> created a new user account")
                        // Create an account in the dataabse using the Authenication data
                        var arrayOfEmailWords = email.components(separatedBy: "@")
                        ref.child("users").child((user?.uid)!).setValue([
                            "name":arrayOfEmailWords[0],
                            "profilePicture":"default",
                            "bio":"This is the default bio! This needs changing!",
                            "uid":user?.uid
                        ])
                    }
                }
                showAlert(title: "Created New Account", message: "You have a new account! Now try to login!")
                self.rocketLogo.stopRotating()
            }else{
                emailField.shake()
                rocketLogo.stopRotating()
            }
        }else{
            passwordField.shake()
            passwordAgainField.shake()
            showAlert(title: "Failed To Register", message: "The passwords do not match! Try again!")
            rocketLogo.stopRotating()
        }
    }
}
