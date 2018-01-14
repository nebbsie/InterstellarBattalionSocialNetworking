//
//  LoginController.swift
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
import FirebaseStorage
import FirebaseAuth
import CoreData

class LoginController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rocket: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        emailField.underlined()
        passwordField.underlined()
        // Get from core data and login if found
        let fetch: NSFetchRequest<Account> = Account.fetchRequest()
        do {
            let account = try CoreDataHelper.context.fetch(fetch)
            print(account.count)
            if account.count > 0 {
                if account[0].email != nil {
                    emailField.text = account[0].email!
                    passwordField.text = account[0].password!
                    loginButtonAction()
                }else{
                    print("Error Signing In")
                }
            }
        } catch  {
            print("error getting core data")
        }
    }
    
    // Called when login button clicked
    @IBAction func loginButtonAction(){
        let email: String = emailField.text!
        let password: String = passwordField.text!
        var success: Bool = true
       
        /*
         Check if email and password are not empty and if not
         send a request to login.
         */
        if(email != ""){
            if(password != ""){
                 rocket.startRotating()
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // Error logging in
                    if error != nil{
                        print("UserHandler -> failed to login")
                        self.rocket.stopRotating()
                        self.passwordField.shake()
                        self.emailField.shake()
                        success = false
                    }else{
                        print("UserHandler -> logged in successfully")
                        // Set the userAccount to the logged in account
                        userAccount = user
                        // Create an account for CoreData
                        let acc = Account(context: CoreDataHelper.context)
                        acc.email = email
                        acc.password = password
                        acc.autoLogin = false
                        // Save to core data
                        CoreDataHelper.saveContext()
                        // Navigate to the newsFeed page.
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let secondVC = storyBoard.instantiateViewController(withIdentifier: "newsFeed")
                        self.present(secondVC, animated: true, completion: nil)
                    }
                }
            }else{
                self.passwordField.shake() // Password empty
            }
        }else{
           self.emailField.shake() // Email empty
        }
        if(!success){
            rocket.stopRotating()
            self.passwordField.shake()
            self.emailField.shake()
        }
    }
}
