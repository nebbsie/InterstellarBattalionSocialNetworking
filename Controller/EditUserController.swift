//
//  EditUserController.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 13/01/2018.
//  Copyright © 2018 Aaron Nebbs. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import CoreData

class EditUserController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var pictureChoices = ["default", "rocket", "map","matrix","work"];
    var proPic:String! = "default"
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var bioEdit: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the bio edit textView to look the same as the text field.
        bioEdit.layer.cornerRadius = 5
        bioEdit.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bioEdit.layer.borderWidth = 0.5
        bioEdit.clipsToBounds = true
        getUserDetails()
        let i = pictureChoices.index(of: (userDetails?.profilePic)!)
        picker.selectRow(i!, inComponent: 0, animated: true)
        
        proPic = userDetails?.profilePic
    }
    
    // Gets the user details from
    func getUserDetails(){
        for user in users {
            if  profileToView == user.uid {
                self.usernameEdit.text = user.name
                self.bioEdit.text = user.bio
            }
        }
    }
    
    // Save data into firebase
    @IBAction func saveData(_ sender: Any) {
    
        ref.child("users").child((userAccount?.uid)!).setValue([
                "name":usernameEdit.text,
                "profilePicture":proPic,
                "bio":bioEdit.text,
                "uid":userAccount?.uid
                ])
        
        // Go back to the newsfeed page
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "newsFeed")
        self.present(secondVC, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pictureChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pictureChoices[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        proPic = pictureChoices[row]
    }
    
}
