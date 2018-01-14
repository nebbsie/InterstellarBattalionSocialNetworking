//
//  Helpers.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage


var ref:DatabaseReference!
var userAccount:User? = nil
var userDetails:UserDetails? = nil
var posts = [UserPost]()
var users = [UserDetails]()
var profileToView:String?
let str = Storage.storage()


// Returns the profile picture
func getProfilePic(pic:String) -> UIImage {
    if pic == "work" {
        return UIImage(named:"work")!
    }else if pic == "matrix" {
        return UIImage(named:"matrix")!
    }else if pic == "map" {
        return UIImage(named:"map")!
    }else if pic == "rocket" {
        return UIImage(named:"rocket")!
    }else if pic == "default" {
       return UIImage(named:"account")!
    }else{
       return UIImage(named:"rocket")!
    }
}

// Converts hex codes to colours.
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UITextField{
    // Used to underline the text field.
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    
    // Used to show alerts on scren.
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    // Starts rotation a UIView
    func startRotating(duration: Double = 1) {
        let key = "rotation"
        
        if self.layer.animation(forKey: key) == nil {
            let ani = CABasicAnimation(keyPath: "transform.rotation")
            ani.duration = duration
            ani.repeatCount = Float.infinity
            ani.fromValue = 0.0
            ani.toValue = Float(Double.pi * 2.0)
            self.layer.add(ani, forKey: key)
        }
    }
    
    // Stops rotating the UIView
    func stopRotating() {
        let key = "rotation"
        if self.layer.animation(forKey: key) != nil {
            self.layer.removeAnimation(forKey: key)
        }
    }
    
    // Shakes a UIView
    func shake() {
        self.transform = CGAffineTransform(translationX: 30, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            // Set the UIView back to its original position
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


