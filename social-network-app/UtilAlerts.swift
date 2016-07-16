//
//  UtilAlerts.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 02/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import UIKit

class UtilAlerts {
    
    //MARK: - Titles
    struct Titles {
        static let ERROR_EMAIL_ALREADY_IN_USE = "Email already exists"
        static let ERROR_WEAK_PASSWORD = "Weak password"
        static let MISSING_EMAIL_PASSWORD = "Email and password required"
        static let ERROR_NETWORK_REQUEST_FAILED = "No network connection"
        static let UNKNOWN = "Unknown reason"
        static let ERROR_WRONG_PASSWORD = "Wrong password"
        static let ERROR_USER_NOT_FOUND = "Wrong user"
        static let ERROR_INTERNAL_ERROR = "Email is not valid"
        static let MISSING_FIELDS = "All fields are required"
        static let POST_RELATED = "There is a problem with your post"
        static let PASSWORD_RECOVERY = "Missing information"
    }
    
    //MARK: - Messages
    struct LoginMessages {
        static let UNKNOWN_ERROR_LOGIN = "Login failed."
        static let ERROR_WRONG_PASSWORD = "Please check your password."
        static let ERROR_USER_NOT_FOUND = "The email does not exists."
        static let ERROR_INTERNAL_ERROR = "Please insert a valid email."
        static let MISSING_EMAIL_PASSWORD = "You must enter an email and a password"
    }
    
    struct CreateAccountMessages {
        static let UNKNOWN_ERROR_CREATE_LOGIN = "The account was created but the login failed."
        static let UNKNOWN_ERROR_CREATE = "The account cannot be created."
    }
    
    struct GeneralMessages {
        static let UNKNOWN = "An unknown error ocurred."
        static let MISSING_FIELDS = "You must enter all fields."
        static let ERROR_EMAIL_ALREADY_IN_USE = "The email address is already in use by another account."
        static let ERROR_WEAK_PASSWORD = "The password must be 6 characters long or more."
    }
    
    struct NetworkMessages {
        static let ERROR_NETWORK_REQUEST_FAILED = "Please check your network connection."
    }
    
    struct PostMessages {
        static let MISSING_DESCRIPTION = "You must insert a description."
    }
    
    struct PassRecoveryMessages {
        static let OLD_PASS_MISSING = "You must insert the current password."
        static let NEW_PASS_MISSING = "You must insert the new password."
        static let INCORRECT_PASSWORD = "The 'Old Password' does not match the actual password. Please insert it again."
    }
    
    
    //MARK: - Show Alert
    func showAlert(vc: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        vc.presentViewController(alert, animated: true, completion: nil)
    }

    
}