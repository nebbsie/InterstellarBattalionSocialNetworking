//
//  Post.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 07/12/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserPost {
    
    let message:String!
    let addedByUser:String!
    let ref:DatabaseReference?
    let key:String!
    var details:UserDetails!
    
    
    init(message:String, addedByUser:String) {
        self.message = message
        self.addedByUser = addedByUser
        self.ref = nil
        self.key = ""
        self.details = nil
    }
    
    init (snapshot:DataSnapshot){
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.details = nil
        
        
        if let postMessage = (snapshot.value as? NSDictionary)?["message"] as? String {
            self.message = postMessage
        }else{
            self.message = ""
        }
        
        if let postUser = (snapshot.value as? NSDictionary)?["addedByUser"] as? String {
            self.addedByUser = postUser
        }else{
            self.addedByUser = ""
        }
        
    }
    
    func toAnyObject() -> AnyObject {
        return (["message": message,"addedByUser": addedByUser] as AnyObject)
    }
    
}
