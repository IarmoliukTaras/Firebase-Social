//
//  DataService.swift
//  FirebaseSocial
//
//  Created by 123 on 01.06.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let BASE_REF = FIRDatabase.database().reference()
let BASE_STORAGE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    private var _baseRef = BASE_REF
    private var _postsRef = BASE_REF.child("posts")
    private var _usersRef = BASE_REF.child("users")
    
    private var _postPicsRef = BASE_STORAGE.child("post-pics")
    
    var baseRef: FIRDatabaseReference {
        return _baseRef
    }
    
    var postsRef: FIRDatabaseReference {
        return _postsRef
    }
    
    var usersRef: FIRDatabaseReference {
        return _usersRef
    }
    
    var postPicsRef: FIRStorageReference {
        return _postPicsRef
    }
    
    var currentUserRef: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = usersRef.child(uid!)
        return user
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        usersRef.child(uid).updateChildValues(userData)
    }

}
