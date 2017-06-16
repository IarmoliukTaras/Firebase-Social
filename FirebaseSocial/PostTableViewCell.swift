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
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
                self.post.addLike(isAdd: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
                self.post.addLike(isAdd: false)
                self.likesRef.removeValue()
            }
        })
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.postTextView.text = post.caption
        self.likesLabel.text = String(post.likes)
        
        self.likesRef = DataService.ds.currentUserRef.child("likes").child(self.post.postKey)
        
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
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
            } else {
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
            }
        })
    }

}
