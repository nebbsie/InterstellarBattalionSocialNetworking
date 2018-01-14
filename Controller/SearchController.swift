//
//  SearchController.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var possibleUsers = [UserDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // Setup the top bar.
    func setupNavBar(){
        // Set the page title
        let pageTitle = UILabel()
        pageTitle.text = "Search"
        pageTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(17))
        pageTitle.textColor = hexStringToUIColor(hex: "#393939")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageTitle)
        
        // Setup the search bar
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = hexStringToUIColor(hex: "#393939")
        navigationItem.titleView = searchBar
    }
    // Search for possible users when a new char is entered
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        // Refresh possible users array
        possibleUsers.removeAll()
        
        // Fill possible useres array with users that match the search text
        for u in users {
            print(u.name)
            if u.name.lowercased().contains(textSearched.lowercased()) {
                if u.uid != userAccount?.uid {
                    possibleUsers.append(u)
                }
            }
        }
        // Refresh the table
        table.reloadData()
    }
    
    // Set the size of the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleUsers.count
    }
    
    // Set the content of the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchUserCell
        
        let u = possibleUsers[indexPath.row]
        cell.button.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.button.tag = indexPath.row
        cell.name.text = u.name
        cell.uid = u.uid
        cell.picture.image = getProfilePic(pic: u.profilePic)
        return cell
    }

    // Called when click the view profile button.
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        profileToView = possibleUsers[buttonTag].uid
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "searchScreen")
        self.present(secondVC, animated: true, completion: nil)
    }
}















