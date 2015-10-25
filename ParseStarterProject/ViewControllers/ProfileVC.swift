//
//  ProfileVC.swift
//  TravelMate
//
//  Created by Julian Engel on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit

class ProfileVC: BaseViewController {
    
    let facebookCredentials = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var ppIV : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = facebookCredentials.objectForKey("name") as! NSString as String

        returnUserProfileImage(facebookCredentials.objectForKey("fbID") as! NSString as String)
        
        nameLabel.layer.cornerRadius = 8
        nameLabel.clipsToBounds = true
        
        logOutButton.layer.cornerRadius = 8
        logOutButton.clipsToBounds = true
        
    }
    
    func returnUserProfileImage(fbID: NSString)
    {
        let str = "https://graph.facebook.com/\(fbID)/picture?type=large"
        let imageURL: NSURL = NSURL(string: str)!
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let data = NSData(contentsOfURL: imageURL)
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ppIV.image = image
                self.ppIV.layer.cornerRadius = self.ppIV.frame.size.width/2
                self.ppIV.clipsToBounds = true
            });
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "Profile-1")
    }
    
    @IBAction func logOut(sender: AnyObject){
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        print("Logged the user out")
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("logIn")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func makeProfilePic(image: UIImageView)
    {
        
        
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.borderWidth = 3
    }
}
