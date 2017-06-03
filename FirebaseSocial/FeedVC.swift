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
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.ds.postsRef.observe(.value, with: {(snapshot) in
            print(snapshot.value)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
    }
}
