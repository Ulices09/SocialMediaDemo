//
//  PostCell.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 21/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var post: Post!
    var likesRef: DatabaseReference!
    var postRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLikeImageViewTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLikeImageViewTapGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PostCell.onTapLikeImageView))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(singleTap)
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.postRef = DataService.ds.postsRef.child(post.postKey)
        self.likesRef = DataService.ds.currentUserLikesRef.child(post.postKey)
        
        self.postText.text = post.text
        self.likesLabel.text = "\(post.likes)"
        self.setPostImage(imageUrl: post.imageUrl)
        self.setLikeObserver()
    }
    
    
    func setPostImage(imageUrl: String) {        
        if let image = FeedViewController.imageCache.object(forKey: imageUrl as NSString) {
            self.postImage.image = image
        } else {
            let imageRef = Storage.storage().reference(forURL: imageUrl)
            
            imageRef.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error) in
                if error != nil {
                    print("IMAGE DOWNLOAD LOG - ", error as Any)
                } else {
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImage.image = img
                            FeedViewController.imageCache.setObject(img, forKey: imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
    
    func setLikeObserver() {
        likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImageView.image = UIImage(named: "empty-heart")
                //self.likesRef.child(self.post.postKey).removeValue()
                //self.updatePostLikes(like: false)
            } else {
                self.likeImageView.image = UIImage(named: "filled-heart")
                //self.likesRef.child(self.post.postKey).setValue(true)
                //self.updatePostLikes(like: true)
            }
        })
    }
    
    @objc func onTapLikeImageView() {
        likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImageView.image = UIImage(named: "filled-heart")
                self.likesRef.setValue(true)
                self.updatePostLikes(like: true)
            } else {
                self.likeImageView.image = UIImage(named: "empty-heart")
                self.likesRef.removeValue()
                self.updatePostLikes(like: false)
            }
        })
    }
    
    func updatePostLikes(like: Bool) {
        var likes: Int!
        
        if like {
            likes = post.likes + 1
            postRef.updateChildValues(["likes": likes])
        } else {
            likes = post.likes - 1
            postRef.updateChildValues(["likes": likes])
        }
    }
    
//    func setPostImage(imageURL: String) {
//        let url = URL(string: imageURL)!
//        DispatchQueue.global().async {
//            do{
//                let data = try Data(contentsOf: url)
//                DispatchQueue.main.sync {
//                    self.postImage.image = UIImage(data: data)
//                }
//            } catch let error as NSError {
//                print("Error loading post image:", error)
//            }
//
//        }
//    }

}
