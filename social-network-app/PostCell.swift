//
//  PostCell.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    //MARK: - Properties
    
    var request: Request?
    var requestPhoto: Request?
    var currentUserLikeRef: FIRDatabaseReference!
    var post: Post!
    var user = FIRAuth.auth()?.currentUser
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImage: RoundedImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    //MARK: - Cell Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        postImage.clipsToBounds = true
    }
    
    
    //MARK: - Cell Configuration

    func configureCell (post: Post, img: UIImage?) {
        self.post = post
        
        currentUserLikeRef = DataService.ds.REF_BASE.child("users/\(user!.uid)/likes/\(post.postKey)")
        
        numberOfLikes.text = "\(post.likes)"
        postDescription.text = post.postDescription
        
        if img != nil {
            postImage.hidden = false
            postImage.image = img
        } else if let imgUrl = post.postImageUrl {
            request = Alamofire.request(.GET, imgUrl).validate(contentType: ["image/*"]).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                if error == nil {
                    if let imgData = data {
                        self.postImage.hidden = false
                        let img = UIImage(data: imgData)!
                        FeedVC.cache.setObject(img, forKey: imgUrl)
                        self.postImage.image = img
                    }
                }
            })
        } else {
            postImage.hidden = true
        }
        
        //Like button
        currentUserLikeRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let _ = snapshot.value as? NSNull {
                self.setHeartImages("heart-empty")
            } else {
                self.setHeartImages("heart-full")
            }
        }
        
        //User info
        DataService.ds.REF_USERS.child(post.username).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let userInfo = snapshot.value as? [String: AnyObject] {
                if let username = userInfo["username"] as? String {
                    self.userName.text = username
                }
                if let photo = userInfo["photo"] as? String {
                    let url = NSURL(string: photo)!
                    self.requestPhoto = Alamofire.request(.GET, url).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                        if error == nil {
                            if let imgData = data {
                                let img = UIImage(data: imgData)
                                self.userImage.image = img
                            }
                        }
                    })
                } else {
                    self.userImage.image = UIImage(named: "profile")
                }
            }
        }
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onLikeBtnPressed(sender: UIButton) {
        currentUserLikeRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let _ = snapshot.value as? NSNull {
                self.setHeartImages("heart-full")
                self.post.increaseNrLikes()
                self.currentUserLikeRef.setValue(true)
            } else {
                self.setHeartImages("heart-empty")
                self.post.decreaseNrLikes()
                self.currentUserLikeRef.removeValue()
            }
        }
    }
    
    
    //MARK: - Aux
    
    func setHeartImages(imgName: String) {
        let img = UIImage(named: imgName)
        likeBtn.setImage(img, forState: .Normal)
    }
    
}
