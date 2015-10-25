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
        super.viewDidLoad()

        if FBSDKAccessToken.currentAccessToken() == nil{
            print("No One Logged In")
        } else {
            print("Someone is logged in")
            self.performSegueWithIdentifier("LogInSegue", sender: self)
        }

        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        loginButton.center.y = loginButton.center.y + 50
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    func newRule(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                self.facebookCredentials.setObject(userEmail, forKey: "mail")
                let userName : NSString = result.valueForKey("name") as! NSString
                self.facebookCredentials.setObject(userName, forKey: "name")
                let fbID : NSString = result.valueForKey("id") as! NSString
                self.facebookCredentials.setObject(fbID, forKey: "fbID")
                self.performSegueWithIdentifier("LogInSegue", sender: self)
            }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil {
            print("Login complete.")
            newRule()
            self.performSegueWithIdentifier("LogInSegue", sender: self)
        }
        else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }
}
