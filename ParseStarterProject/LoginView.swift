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

class LoginView: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            
            
            self.logInViewController.fields = [PFLogInFields.UsernameAndPassword,
                PFLogInFields.LogInButton, PFLogInFields.SignUpButton,
                PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = "Travel Mate"
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            let SignUpLogoTitle = UILabel()
            SignUpLogoTitle.text = "Travel Mate"
            
            self.signUpViewController.signUpView!.logo = SignUpLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            
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
