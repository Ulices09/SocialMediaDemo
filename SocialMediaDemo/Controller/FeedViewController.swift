//
//  FeedViewController.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 8/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var postTextField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache = NSCache<NSString, UIImage>()
    var imageChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        setAddImageTapGesture()
        
        fetchPosts()
    }
    
    func fetchPosts() {
        DataService.ds.postsRef.observe(.value, with: {(snapshot) in
            
            self.posts = []
            
            if let snapshotObjects = snapshot.children.allObjects as? [DataSnapshot] {
                for snapshotObject in snapshotObjects {
                    if let postDict = snapshotObject.value as? Dictionary<String, AnyObject> {
                        let key = snapshotObject.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }

    @IBAction func signOutBtnPressed(_ sender: UIBarButtonItem) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func setAddImageTapGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.onTapItemImageView))
        addImageView.isUserInteractionEnabled = true
        addImageView.addGestureRecognizer(singleTap)
    }
    
    @objc func onTapItemImageView() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageView.image = image
            imageChanged = true
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPostBtnPressed(_ sender: Any) {
        guard let postText = postTextField.text, postText != "" else {
            return
        }
        
        guard let image = addImageView.image, imageChanged else {
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.postsImagesRef.child(imageUid).putData(imageData, metadata: metadata, completion: {(storageMetadada, error) in
                if error != nil {
                    print("ERROR LOG - ", error)
                } else {
                    if let imageUrl = storageMetadada?.downloadURL()?.absoluteString {
                        self.insertPost(text: postText, imageUrl: imageUrl)
                        self.resetInputValues()
                    }
                }
            })
        }
    }
    
    func insertPost(text: String, imageUrl: String) {
        let post: Dictionary<String, Any> = [
            "text": text,
            "imageUrl": imageUrl,
            "likes": 0
        ]
        
        let newPost = DataService.ds.postsRef.childByAutoId()
        newPost.setValue(post)
        
    }
    
    func resetInputValues() {
        postTextField.text = nil
        addImageView.image = UIImage(named: "add-image")
        self.imageChanged = false
    }
    
}




















