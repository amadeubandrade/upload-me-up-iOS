//
//  DataService.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 29/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()

    //MARK: - Properties

    private var _REF_BASE = FIRDatabase.database().reference()
    private var _REF_STORAGE = FIRStorage.storage().referenceForURL("gs://social-network-c3fed.appspot.com")

    
    //MARK: - Computed Properties
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE: FIRStorageReference {
        return _REF_STORAGE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_BASE.child("users")
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_BASE.child("posts")
    }

    
    //MARK: - Functions
    
    func createFirebaseUser(uid: String, userInfo: [String: AnyObject]) {
        REF_USERS.child(uid).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if snapshot.value is NSNull {
                self.REF_USERS.child(uid).setValue(userInfo)
            }
        }
    }

    func createFirebasePostWithAutoID(userId: String, postInfo: [String: AnyObject]) {
        //Create post
        let autoIDPost = REF_POSTS.childByAutoId()
        autoIDPost.setValue(postInfo)
        //Save to current user
        let postKey = autoIDPost.key
        REF_BASE.child("users/\(userId)/posts").updateChildValues([postKey: true])
    }
    
}