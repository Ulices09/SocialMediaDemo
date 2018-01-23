//
//  DataService.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 22/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import Foundation
import FirebaseDatabase

let ref = Database.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = ref
    private var _REF_POSTS = ref.child("posts")
    private var _REF_USERS = ref.child("users")
    
    var REF_BASE: DatabaseReference {
        return self._REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return self._REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return self._REF_USERS
    }
    
    func crateFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        _REF_USERS.child(uid).updateChildValues(userData)
    }
}
