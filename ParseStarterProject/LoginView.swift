//
//  LoginView.swift
//  ParseStarterProject-Swift
//
//  Created by Julian Engel on 23/10/2015.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import ParseFacebookUtilsV4

let logInSegue = "LogInSegue"



class LoginView: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    
    var logInViewController: MyLogInViewController! = MyLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        if (PFUser.currentUser() == nil) {
            
            
            self.logInViewController.fields = [PFLogInFields.UsernameAndPassword,
                PFLogInFields.LogInButton, PFLogInFields.SignUpButton,
                PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton, PFLogInFields.Facebook]
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = ""
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            let SignUpLogoTitle = UILabel()
            SignUpLogoTitle.text = ""
            
            self.signUpViewController.signUpView!.logo = SignUpLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
        } else {
            performSegueWithIdentifier(logInSegue, sender: nil)
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let my_id = FBSDKAccessToken.currentAccessToken().userID
        print(my_id)
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(my_id)/picture?type=large")
        print(facebookProfileUrl)
//        
//        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
//            let my_image = UIImage(data: data)
//            print(my_image)
//        }
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let theName = result["name"]
                    let theMail = result["email"]
                    let user = PFObject(className: "Registered")
                    
                    user["facebook"] = PFUser.currentUser()
                    user["name"] = theName
                    user["email"] = theMail
                    user["image"] = String(facebookProfileUrl!)
                    
                    user.saveInBackgroundWithBlock({
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("YAHOOOOOOOO")
                        } else {
                            // There was a problem, check error.description
                        }
                    })

                    
                    
                }
            })
        }

        
        
    }
    
        func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to login...")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        print("Failed to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        print("User dismissed sign up.")
        
    }
    
    @IBAction func simpleAction(sender: AnyObject) {
        
        self.presentViewController(self.logInViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        PFUser.logOut()
        print("Logged out the PFUser")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



class MyLogInViewController : PFLogInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hue: 207/360, saturation: 40/100, brightness: 48/100, alpha: 1.0)

        let imageName = "yourImage.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        view.addSubview(imageView)
        
    }
}
