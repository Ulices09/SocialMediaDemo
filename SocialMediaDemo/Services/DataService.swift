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
    
    private var _baseRef = ref
    private var _postsRef = ref.child("posts")
    private var _usersRef = ref.child("users")
    
    var baseRef: DatabaseReference {
        return self._baseRef
    }
    
    var postsRef: DatabaseReference {
        return self._postsRef
    }
    
    var usersRef: DatabaseReference {
        return self._usersRef
    }
    
    func crateFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        _usersRef.child(uid).updateChildValues(userData)
    }
}
