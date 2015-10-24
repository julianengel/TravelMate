/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    let facebookCredentials = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        newRule()
        
        if FBSDKAccessToken.currentAccessToken() == nil{
            
            print("No One Logged In")
            
            
            
        }
        
        else {
            
            print("Someone is logged in")
            self.performSegueWithIdentifier("LogInSegue", sender: self)

            returnUserData()
            
        }
        
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        
       loginButton.delegate = self
        
        self.view.addSubview(loginButton)
        
        
                super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
                if let id: NSString = result.valueForKey("id") as? NSString {
                    print("ID is: \(id)")
                    self.facebookCredentials.setObject(id, forKey: "id")
                   // self.returnUserProfileImage(id)
                } else {
                    print("ID es null")
                }
                
                
            }
        })
    }

    
    func newRule(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                self.facebookCredentials.setObject(userEmail, forKey: "mail")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                self.facebookCredentials.setObject(userName, forKey: "name")
                
            }
        })
    }
        
        
    
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            print("Login complete.")
            self.performSegueWithIdentifier("LogInSegue", sender: self)
            
            
            
            
            
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User logged out...")
    }
    
    

    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        print(facebookCredentials.objectForKey("id"))
        print(facebookCredentials.objectForKey("name"))
        
        // Dispose of any resources that can be recreated.
    }
}
