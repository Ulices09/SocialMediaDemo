//
//  PostCell.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 21/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post) {
        self.postText.text = post.text
        self.likesLabel.text = "\(post.likes)"
        self.setPostImage(imageURL: post.imageUrl)
    }
    
    func setPostImage(imageURL: String) {
        let url = URL(string: imageURL)!
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.sync {
                    self.postImage.image = UIImage(data: data)
                }
            } catch let error as NSError {
                print("Error loading post image:", error)
            }
            
        }
    }

}
