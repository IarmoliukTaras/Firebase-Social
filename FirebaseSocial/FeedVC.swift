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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let KEY_UID = "uid"
    
    @IBOutlet weak var addImage: CircleImageView!
    @IBOutlet weak var postTable: UITableView!
    @IBOutlet weak var captionField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.postsRef.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts.removeAll()
                for snap in snapshot {
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
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = self.captionField.text, caption != "" else {
            print("Caption must be entered")
            return
        }
        guard let img = addImage.image, imageSelected == true else {
            print("Image must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.postPicsRef.child(imgUid).put(imgData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("Unable upload image to Firebase storage")
                } else {
                    print("Success upload image to Firebase storage")
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                        self.postToFirebase(imgUrl: downloadUrl)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text! as AnyObject,
        "imageURL": imgUrl as AnyObject,
        "likes": 0 as AnyObject
        ]
        let firebasePost = DataService.ds.postsRef.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        addImage.image = #imageLiteral(resourceName: "add-image")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("Image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostTableViewCell()
        }
    }
}
