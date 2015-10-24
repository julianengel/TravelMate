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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let query = PFQuery(clasrsName: "Registered")
//        query.whereKey("facebook", equalTo: PFUser.currentUser()!)
//        let objects = query.findObjectsInBackground()
        
      
//        print(objects)
        ppIV.image = UIImage(imageLiteral: "12065615_10154230974098906_793892778809770643_n.jpg")
        
        let profilePicture = PFObject(className: "Registered")
        let userImageFile = profilePicture["image"] as! PFFile
        
        userImageFile.getDataInBackgroundWithBlock( {(imageData, error) -> Void in
            if (error == nil) {
                let image = UIImage(data:imageData!)
                self.ppIV.image = image
            }
        })
        
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
    
    
    func makeProfilePic(image: UIImageView){
        
        
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.borderWidth = 3
    }
}
