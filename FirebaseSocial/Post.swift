//
//  Post.swift
//  FirebaseSocial
//
//  Created by 123 on 03.06.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import Foundation
import Firebase
class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageURL"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.postsRef.child(self._postKey)
    }
    
    func addLike(isAdd: Bool) {
        if isAdd {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        self._postRef.child("likes").setValue(self._likes)
    }
}
