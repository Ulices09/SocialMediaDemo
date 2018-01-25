//
//  DataService.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 22/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let REF_DATABASE = Database.database().reference()
let REF_STORAGE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _baseRef = REF_DATABASE
    private var _postsRef = REF_DATABASE.child("posts")
    private var _usersRef = REF_DATABASE.child("users")
    
    private var _postsImagesRef = REF_STORAGE.child("post-pics")
    
    var baseRef: DatabaseReference {
        return self._baseRef
    }
    
    var postsRef: DatabaseReference {
        return self._postsRef
    }
    
    var usersRef: DatabaseReference {
        return self._usersRef
    }
    
    var postsImagesRef: StorageReference {
        return self._postsImagesRef
    }
    
    func crateFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        _usersRef.child(uid).updateChildValues(userData)
    }
}
