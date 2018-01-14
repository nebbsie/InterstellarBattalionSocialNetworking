//
//  NewPostController.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 24/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class NewPostController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var newPostTextField: UITextField!
    var charLimit:Int = 255
    // Create a root reference
    let storageRef = str.reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the top navigation bar.
        setupNavBar()
        // Sets the colour of the UITabBar above the keyboard and fonts.
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 12)!,NSAttributedStringKey.foregroundColor : hexStringToUIColor(hex: "#393939"),], for: .normal)
        // Bring the keybaord up
        newPostTextField.becomeFirstResponder()
        // Setup the toolbar buttons
        setupToolbar()
    }
    
    // Called when a the keyboard is typed.
    func textViewDidChange(_ textView: UITextView) {
        let charLeft:Int = charLimit - textView.text.count
        updateCharCount(charCount: charLeft)
    }

    // Setup bar above the keyboard.
    func setupToolbar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let image = UIImage(named: "Post")?.withRenderingMode(.alwaysOriginal)
        let doneButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.done, target: self, action: #selector(postMessage))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        newPostTextField.inputAccessoryView = toolBar
    }
    
    // Setup the navigation bar.
    func setupNavBar(){
        let pageTitle = UILabel()
        pageTitle.text = "New Post"
        pageTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        pageTitle.textColor = hexStringToUIColor(hex: "#393939")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitle)
        updateCharCount(charCount: charLimit)
    }
    
    // Changes the char count in navbar and changes colour.
    func updateCharCount(charCount: Int){
        // Set the settings button
        let edit = UILabel()
        edit.text = "\(charCount)"
        edit.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        edit.textColor = hexStringToUIColor(hex: "#393939")
        
        // Sets the colour based on char count.
        if(charCount < 75){
            edit.textColor = hexStringToUIColor(hex: "#FF9500")
        }
        if(charCount < 25){
            edit.textColor = hexStringToUIColor(hex: "#C60303")
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: edit)
    }
    
    // Called when trying to post a message.
    @objc func postMessage(){
        
        let message:String = newPostTextField.text!
        let addedByUser:String = (userAccount?.uid)!
        
        // Attempt to send post if message is below char limit.
        if(message.count < charLimit){
            // Create the userpost
            let post = UserPost(message:message,addedByUser:addedByUser)
            // Post the message
            ref.child("posts").childByAutoId().setValue(post.toAnyObject())
            
            // Go to the news feed after posting
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyBoard.instantiateViewController(withIdentifier: "newsFeed")
            self.present(secondVC, animated: true, completion: nil)
        }else{
            showAlert(title: "Failed To Post", message: "You are over the \(charLimit) char limit! Try again with a smaller message")
        }
    }
    
    // Called when canceling a new post.
    @objc func cancelPressed(){
        view.endEditing(true)
    }
    
}

