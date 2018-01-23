//
//  Post.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 22/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import Foundation

class Post {
    
    private var _postKey: String!
    private var _text: String!
    private var _imageUrl: String!
    private var _likes: Int!
    
    init(text: String, imageUrl: String, likes: Int) {
        self._text = text
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let text = postData["text"] as? String {
            self._text = text
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
    
    var postKey: String {
        return self._postKey
    }
    
    var text: String {
        return self._text
    }
    
    var imageUrl: String {
        return self._imageUrl
    }
    
    var likes: Int {
        return self._likes
    }
}
