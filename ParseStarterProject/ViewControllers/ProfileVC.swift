//
//  ProfileVC.swift
//  TravelMate
//
//  Created by Julian Engel on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit


class ProfileVC: BaseViewController {
    
    
    let facebookCredentials = NSUserDefaults.standardUserDefaults()
    
   
    @IBOutlet weak var ppIV : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = facebookCredentials.objectForKey("name") as! String
        mailLabel.text = facebookCredentials.objectForKey("mail") as! String
        returnUserProfileImage()

        
        
        
        
        //        ppIV.image = UIImage(imageLiteral: "12065615_10154230974098906_793892778809770643_n.png")
        
        

        
//        var facebookProfileUrl = NSURL(string: "https://graph.facebook.com/\(facebookCredentials.objectForKey("id" as! String))/picture?type=large")
//        
//            if let data = NSData(contentsOfURL: facebookProfileUrl!) {
//            print("here;s okay")
//            
//            let myImage = UIImage(data: data)
//                
//                ppIV.image = myImage }
//
//        
//            
//     
//        
//        
//        
//        
//        let query = PFQuery(clasrsName: "Registered")
//        query.whereKey("facebook", equalTo: PFUser.currentUser()!)
//        let objects = query.findObjectsInBackground()
//        
//      
//        print(objects)
//        
//        
//        ppIV.image = facebookCredentials.objectForKey("image") as! UIImage
//        
        

//        let query = PFQuery(className:"Registered")
//        query.whereKey("facebook", equalTo:PFUser.currentUser()!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) records.")
//                // Do something with the found objects
//                if let objects = objects as [PFObject]! {
//                    for object in objects {
//                        let name = object.objectForKey("name")
//                        let mail = object.objectForKey("email")
//                        self.mailLabel.text = mail as! String
//                        self.nameLabel.text = name as! String
//                        
//                        
//                        
//                        var staring = object.objectForKey("image") as! String
//                        print(staring)
//                        staring = staring.insert("s", ind: 4)
//                        print(staring)
//                        
//                        var imgURL: NSURL = NSURL(string: staring as! String)!
//                        let request: NSURLRequest = NSURLRequest(URL: imgURL)
//                        NSURLConnection.sendAsynchronousRequest(
//                            request, queue: NSOperationQueue.mainQueue(),
//                            completionHandler: {(response,data,error) -> Void in
//                                if error == nil {
//                                    self.ppIV.image = UIImage(data: data!)
//                                }
//                        })
//                        
////                        if let data = NSData(contentsOfURL: string as! NSURL) {
////                            let my_image = UIImage(data: data)
////                            print(my_image)
////                        }
//
//                        
//                    }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//        }
//        
//       
//        
//        
////
////        userImageFile.getDataInBackgroundWithBlock( {(imageData, error) -> Void in
////            if (error == nil) {
////                let image = UIImage(data:imageData!)
////                self.ppIV.image = image
////            }
////        })
//        
//        makeProfilePic(ppIV)
//        
//    
//
//    
//    

        // Do any additional setup after loading the view.
    }

    func returnUserProfileImage()
    {
        let str = "https://graph.facebook.com/10203733069887690/picture?type=large"
        let imageURL: NSURL = NSURL(string: str)!
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let data = NSData(contentsOfURL: imageURL)
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ppIV.image = image
            });
        };
       // 10203733069887690
        
        
//        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
//        pictureRequest.startWithCompletionHandler({
//            (connection, result, error: NSError!) -> Void in
//            if error == nil {
//                print("\(result)")
//                let url = result.objectForKey("url") as! String
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    let data = NSData(contentsOfFile: url)
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        
//                        let image = UIImage(data: data!)
//                        self.ppIV.image = image
//                    });
//                });
//                
//            } else {
//                print(result)
//                //ppIV.image =
//                //print("\(error)")
//            }
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "profiletext")

    }
    
       
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
//    {
//        if error == nil
//        {
//            print("Login complete.")
//            self.performSegueWithIdentifier("LogInSegue", sender: self)
//        }
//        else
//        {
//            print(error.localizedDescription)
//        }
//    }
//
//    
//    
//    
    
    @IBAction func logOut(sender: AnyObject){
        
//        PFUser.logOut()
        print("Logged the user out")
        
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("logIn") as! UIViewController
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

//
//extension String {
//    func insert(string:String,ind:Int) -> String {
//        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
//    }
//}
//
