//
//  SearchUserCell.swift
//  socialNetworking
//
//  Created by Aaron Nebbs on 19/12/2017.
//  Copyright © 2017 Aaron Nebbs. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    var uid:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
