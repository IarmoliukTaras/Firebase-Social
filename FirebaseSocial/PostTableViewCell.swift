//
//  PostTableViewCell.swift
//  FirebaseSocial
//
//  Created by 123 on 01.06.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import UIKit
import Firebase
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
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = String(post.likes)
        
        if image != nil {
            self.postImage.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }

}
