//
//  TweetCell.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/27/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var authorHandleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
