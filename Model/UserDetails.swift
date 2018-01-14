//
//  UserDetails.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 18/12/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserDetails {
    
    var bio:String!
    var name:String!
    var profilePic:String!
    var ref:DatabaseReference?
    var key:String!
    var uid:String!
    
    init(bio:String, name:String, profilePic:String) {
        self.bio = bio
        self.name = name
        self.profilePic = profilePic
        self.ref = nil
        self.key = ""
        self.uid = ""
    }
    
    init (snapshot:DataSnapshot){
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        
        if let _bio = (snapshot.value as? NSDictionary)?["bio"] as? String {
            self.bio = _bio
        }else{
            self.bio = ""
        }
        
        if let _name = (snapshot.value as? NSDictionary)?["name"] as? String {
            self.name = _name
        }else{
            self.name = ""
        }
        
        if let _profilePic = (snapshot.value as? NSDictionary)?["profilePicture"] as? String {
            self.profilePic = _profilePic
        }else{
            self.profilePic = ""
        }
        
        if let _uid = (snapshot.value as? NSDictionary)?["uid"] as? String {
            self.uid = _uid
        }else{
            self.uid = ""
        }
    }
    
    func toAnyObject() -> AnyObject {
        return ([
            "bio":bio,
            "name":name,
            "profilePic":profilePic,
            "uid":uid
            ] as AnyObject)
    }
    
}
