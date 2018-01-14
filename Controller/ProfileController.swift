//
//  ProfileController.swift
//  socialNetworking
//  Profile page is used for own profile and other profiles.
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class ProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts = [UserPost]()
    var postsRef:DatabaseReference!
    var usersRef:DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiPicture: UIImageView!
    @IBOutlet weak var uiBio: UILabel!
    @IBOutlet weak var uiName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsRef = ref.database.reference().child("posts")
        usersRef = ref.database.reference().child("users")
        
        setupNavBar()
        getUserDetails()
        listenForMessages()
    }
    
    // Gets the user details from
    func getUserDetails(){
        for user in users {
            if  profileToView == user.uid {
                self.uiName.text = user.name
                self.uiBio.text = user.bio

                if(user.profilePic == "default"){
                    self.uiPicture.image = UIImage(named:"account")
                }else if (user.profilePic == "rocket"){
                    self.uiPicture.image = UIImage(named:"rocket")
                }else if (user.profilePic == "work"){
                    self.uiPicture.image = UIImage(named:"work")
                }else if (user.profilePic == "map"){
                    self.uiPicture.image = UIImage(named:"map")
                }else if (user.profilePic == "matrix"){
                    self.uiPicture.image = UIImage(named:"matrix")
                }
            }
        }
    }

    func listenForMessages() {
        // Create a listener and updates table everytime a chnage accurs.
        postsRef.observe(.value, with: { (snapshot) in
            // Array to store the userposts.
            var newPosts = [UserPost]()
            // Loop through all of the children.
            for p in snapshot.children {

                // Save the child as an object.
                let post = UserPost(snapshot:p as! DataSnapshot)
                // If the post is by the user, add it to the array of posts.
                if post.addedByUser == profileToView {
                    newPosts.append(post)
                }
            }
            // Update the table view.
            self.posts = newPosts.reversed()
            self.tableView.reloadData()
        })
    }
    
    // Setup the navigation bar.
    func setupNavBar(){
        // Set the page title
        let pageTitle = UILabel()
        pageTitle.text = "My Profile"
        pageTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        pageTitle.textColor = hexStringToUIColor(hex: "#393939")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitle)
        
        if userAccount?.uid == profileToView {
            // Set the edit button
            let edit = UIButton(type: .system)
            edit.setTitle("Edit", for: .normal)
            edit.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))
            edit.setTitleColor(.orange, for: .normal)
            edit.addTarget(self, action:#selector(editButton), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: edit)
        }else{
            // Set the back button
            let edit = UIButton(type: .system)
            edit.setTitle("Back", for: .normal)
            edit.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))
            edit.setTitleColor(.orange, for: .normal)
            edit.addTarget(self, action:#selector(goBack), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: edit)
        }
    }
    
    // Activated when settings button is clicked.
    @objc func editButton() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "editPage")
        self.present(secondVC, animated: true, completion: nil)
    }
    
    // Activated when settings button is clicked.
    @objc func goBack() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "newsFeed")
        self.present(secondVC, animated: true, completion: nil)
    }
    
    // Set the amount of posts to view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Set the posts able to be deleted
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Swipe to delete.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if userAccount?.uid == profileToView {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                // Delete post if it is own.
                postsRef.child(posts[indexPath.row].key).removeValue()
                posts.remove(at: indexPath.row)
            }
        }
    }
    
    // Update the posts on the profile.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proto", for: indexPath) as! TableViewCell
        let post = posts[indexPath.row]
        
        // Get post data from the users information
        for user in users {
            if post.addedByUser == user.uid {
                cell.profile_username.text = user.name
                cell.profile_content.text = post.message
                cell.profile_ProfilePic.image = getProfilePic(pic: user.profilePic)
            }
        }
        return cell
    }
}
