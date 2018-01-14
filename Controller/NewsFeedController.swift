//
//  NewsFeedController.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import CoreData

class NewsFeedController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var postsRef:DatabaseReference!
    var usersRef:DatabaseReference!
    var titleImageView:UIImageView!
    var animating:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firebase references, used for accessing the firebase data.
        postsRef = ref.database.reference().child("posts")
        usersRef = ref.database.reference().child("users")
        // Image used for the top bar, setup the onlick action.
        titleImageView = UIImageView(image: #imageLiteral(resourceName: "rocket"))
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        titleImageView.isUserInteractionEnabled = true
        titleImageView.addGestureRecognizer(singleTap)
        // Setups up the top bar
        setupNavBar()
        // Set the image to start rotating until the data has been loaded.
        titleImageView.startRotating()
        // Get current user details and also listen for messages.
        getUserDetails()
        listenForMessages()
        // Set the current user id as the profile id, for use on the profile page.
        profileToView = userAccount?.uid
    }
    
    // Set the posts able to be deleted if own message
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if posts[indexPath.row].addedByUser == userAccount?.uid {
            return true
        }else {
            return false
        }
    }
    
    // Swipe to delete.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if userAccount?.uid == profileToView {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                // Delete post if it is own.
                postsRef.child(posts[indexPath.row].key).removeValue()
            }
        }
    }
    
    // On lick rocked image action.
    @objc func tapDetected() {
        // If already animating set it to stop, if not animating set it to animate
        if animating {
            titleImageView.stopRotating()
        } else {
            titleImageView.startRotating()
        }
        animating = !animating
    }
    
    // Get all users data and current user
    func getUserDetails() {
        // Get the users information.
        self.usersRef.observe(.value, with: { (snapshot) in
            var details = [UserDetails]()
            // Loop through all of the children.
            for d in snapshot.children {
                // Save the child as a UserDetails object.
                let _details = UserDetails(snapshot: d as! DataSnapshot)
                if _details.uid == userAccount?.uid {
                    userDetails = _details
                }
                details.append(_details);
            }
            users = details
            self.tableView.reloadData()
        })
    }
    
    // Gets all posts from database
    func listenForMessages() {
        // Create a listener and updates table everytime a chnage accurs.
        postsRef.observe(.value, with: { (snapshot) in
            var newPosts = [UserPost]()
            // Look throuh all of the childredn.
            for p in snapshot.children {
                // Create a userpost from the children.
                let post = UserPost(snapshot:p as! DataSnapshot)
                newPosts.append(post)
            }
            posts = newPosts.reversed()
            self.tableView.reloadData()
            self.titleImageView.stopRotating()
        })
    }

    // Setup top bar
    func setupNavBar(){
        // Set the middle image as the logo
        navigationItem.titleView = titleImageView
    
        // Set the page title
        let pageTitle = UILabel()
        pageTitle.text = "News Feed"
        pageTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        pageTitle.textColor = hexStringToUIColor(hex: "#393939")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitle)
        
        // Set the settings button
        let settings = UIButton(type: .system)
        settings.setTitle("Log Out", for: .normal)
        settings.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))
        settings.setTitleColor(.orange, for: .normal)
        settings.addTarget(self, action:#selector(logOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings)
    }
    
    // Activated when logOut button is clicked
    @objc func logOut() {
        CoreDataHelper.deleteRecords()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "loginScreen")
        self.present(secondVC, animated: true, completion: nil)
    }

    // Set the amount of posts to view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Update the posts based on the call.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let post = posts[indexPath.row]
        
        // Get the post infomration based on user info.
        for user in users {
            if post.addedByUser == user.uid {
                cell.username.text = user.name
                cell.postContent.text = post.message
                cell.profilePic.image = getProfilePic(pic: user.profilePic)
            }
        }
        return cell
    }

}
