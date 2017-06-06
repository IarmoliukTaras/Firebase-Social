//
//  PostTableViewCell.swift
//  FirebaseSocial
//
//  Created by 123 on 01.06.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: CircleImageView!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = String(post.likes)
        
    }

}
