//
//  ProfileVC.swift
//  TravelMate
//
//  Created by Julian Engel on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: BaseViewController {

    @IBOutlet weak var ppIV : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let query = PFQuery(clasrsName: "Registered")
//        query.whereKey("facebook", equalTo: PFUser.currentUser()!)
//        let objects = query.findObjectsInBackground()
        
      
//        print(objects)
        ppIV.image = UIImage(imageLiteral: "gPCjrIGykBe.jpg")
        
        let query = PFQuery(className:"Registered")
        query.whereKey("facebook", equalTo:PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) records.")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        let name = object.objectForKey("name")
                        let mail = object.objectForKey("email")
                        self.mailLabel.text = mail as! String
                        self.nameLabel.text = name as! String
                        
                        
                        
                        var staring = object.objectForKey("image") as! String
                        print(staring)
                        staring = staring.insert("s", ind: 4)
                        print(staring)
                        
                        var imgURL: NSURL = NSURL(string: staring as! String)!
                        let request: NSURLRequest = NSURLRequest(URL: imgURL)
                        NSURLConnection.sendAsynchronousRequest(
                            request, queue: NSOperationQueue.mainQueue(),
                            completionHandler: {(response,data,error) -> Void in
                                if error == nil {
                                    self.ppIV.image = UIImage(data: data!)
                                }
                        })
                        
//                        if let data = NSData(contentsOfURL: string as! NSURL) {
//                            let my_image = UIImage(data: data)
//                            print(my_image)
//                        }

                        
                    }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        }
        
       
        
        
//
//        userImageFile.getDataInBackgroundWithBlock( {(imageData, error) -> Void in
//            if (error == nil) {
//                let image = UIImage(data:imageData!)
//                self.ppIV.image = image
//            }
//        })
        
        makeProfilePic(ppIV)
        
    

    
    

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "profiletext")

    }
    
    @IBAction func logOut(sender: AnyObject){
        
        PFUser.logOut()
        print("Logged the user out")
        
        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("logIn") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    func makeProfilePic(image: UIImageView){
        
        
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.borderWidth = 3
    }
}


extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}

