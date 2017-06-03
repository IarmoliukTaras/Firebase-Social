//
//  FeedVC.swift
//  FirebaseSocial
//
//  Created by 123 on 31.05.17.
//  Copyright © 2017 taras team. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let KEY_UID = "uid"
    
    @IBOutlet weak var postTable: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.ds.postsRef.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print(snap)
                    
                    if let postDir = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post.init(postKey: key, postData: postDir)
                        self.posts.append(post)
                    }
                }
            }
            self.postTable.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print(keychainResult)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "signInVC", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
    }
}
