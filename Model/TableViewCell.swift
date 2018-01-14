//
//  TableViewCell.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 23/11/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var profile_username: UILabel!
    @IBOutlet weak var profile_content: UILabel!
    @IBOutlet weak var profile_ProfilePic: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
