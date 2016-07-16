//
//  ProfileVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 12/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Properties
    
    var imagePicker: UIImagePickerController!
    var currentUser: FIRUser!
    var requestGetPhoto: Request?
    var changedphoto = false
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImg: RoundedImage!
    @IBOutlet weak var usernameField: RoundedBorderedTextField!
    @IBOutlet weak var emailField: RoundedBorderedTextField!
    @IBOutlet weak var oldPassField: RoundedBorderedTextField!
    @IBOutlet weak var newPassField: RoundedBorderedTextField!
    @IBOutlet weak var oldPassLbl: UILabel!
    @IBOutlet weak var newPassLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        updateInitialContent()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onChangePicPressed(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                imagePicker.mediaTypes = availableMediaTypes
            }
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onSaveBtnPressed(sender: UIButton) {
        let uid = currentUser.uid
        
        if changedphoto {
            if let img = userImg.image {
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())"
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                DataService.ds.REF_STORAGE.child(imgPath).putData(imgData, metadata: metadata, completion: { (mData: FIRStorageMetadata?, error: NSError?) in
                    if error != nil {
                        print(error)
                    } else {
                        if let downloadedData = mData {
                            if let downloadURL = downloadedData.downloadURL() {
                                let url = downloadURL.absoluteString
                                let path = "\(uid)/photo"
                                DataService.ds.REF_USERS.child(path).setValue(url)
                            }
                        }
                    }
                })
            }
        }
        
        if let username = usernameField.text where username != "" {
            let path = "\(uid)/username"
            DataService.ds.REF_USERS.child(path).setValue(username)
            usernameField.text = ""
            usernameField.placeholder = username
        }
        
        if let email = emailField.text where email != "" {
            let path = "\(uid)/email"
            DataService.ds.REF_USERS.child(path).setValue(email)
            emailField.text = ""
            emailField.placeholder = email
        }
        
        if let oldPass = oldPassField.text where oldPass != "", let newPass = newPassField.text where newPass != "" {
            let path = "\(uid)/email"
            DataService.ds.REF_USERS.child(path).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let email = snapshot.value as? String {
                    
                    //Verify user's old password
                    let credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: oldPass)
                    
                    self.currentUser.reauthenticateWithCredential(credential, completion: { (error) in
                        if error != nil {
                            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_WRONG_PASSWORD, msg: UtilAlerts.PassRecoveryMessages.INCORRECT_PASSWORD)
                        } else {
                            //Update Password
                            self.currentUser.updatePassword(newPass) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    //Password updated.
                                    self.oldPassField.text = ""
                                    self.newPassField.text = ""
                                }
                            }
                        }
                    })
                }
            })
        } else if let oldPass = oldPassField.text where oldPass != "" {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.PASSWORD_RECOVERY, msg: UtilAlerts.PassRecoveryMessages.NEW_PASS_MISSING)
        } else if let newPass = newPassField.text where newPass != "" {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.PASSWORD_RECOVERY, msg: UtilAlerts.PassRecoveryMessages.OLD_PASS_MISSING)
        }
        
    }

    
    //MARK: - Aux
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userImg.image = img
            changedphoto = true
        }
    }
    
    func updateInitialContent() {
        let userID = currentUser.uid
        DataService.ds.REF_USERS.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let userInfo = snapshot.value as? [String: AnyObject] {
                
                if let photo = userInfo["photo"] as? String {
                    let url = NSURL(string: photo)!
                    self.requestGetPhoto = Alamofire.request(.GET, url).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                        if error == nil {
                            if let imgData = data {
                                let image = UIImage(data: imgData)
                                self.userImg.image = image
                            }
                        }
                    })
                }
                
                if let username = userInfo["username"] as? String {
                    self.usernameField.placeholder = username
                }
                
                if let provider = userInfo["provider"] as? String {
                    if provider != "firebase" {
                        self.hideEmailPassFields(true)
                    } else {
                        self.hideEmailPassFields(false)
                        if let email = userInfo["email"] as? String {
                            self.emailField.placeholder = email
                        }
                    }
                }
                
            }
        })
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            requestGetPhoto?.cancel()
            changedphoto = false
        }
    }
    
    func hideEmailPassFields(boolean: Bool) {
        oldPassField.hidden = boolean
        newPassField.hidden = boolean
        oldPassLbl.hidden = boolean
        newPassLbl.hidden = boolean
        emailField.hidden = boolean
        emailLbl.hidden = boolean
    }


}
