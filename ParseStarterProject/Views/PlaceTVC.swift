//
//  PlaceTVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class PlaceTVC: MGSwipeTableCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    
    @IBOutlet weak var jon: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var averageImageView: UIImageView!
    
    var downloaded: Bool = false
    var audioData: NSData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        speakerImage.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(place: PlaceModel) {
        nameLabel.text = place.name
        
        print(place)
        typeLabel.text = Constatnts.setType(place.type!)
        languageLabel.text = Constatnts.setLanguage(place.language!)
        
        let str = "https://graph.facebook.com/\(place.facebookID!)/picture?type=large"
        print(str)
        let imageURL: NSURL = NSURL(string: str)!
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let data = NSData(contentsOfURL: imageURL)
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.jon.image = image
                self.jon.layer.cornerRadius = self.jon.frame.size.width/2
                self.jon.clipsToBounds = true
            });
        };
        let rating = place.rating!
        let count = Float(place.count!)
        let average = rating/count
        if average >= 4.5 {
            averageImageView.image = UIImage(named: "star-5")
        } else if (average < 4.5 && average >= 3.5) {
            averageImageView.image = UIImage(named: "star-4")
        } else if (average < 3.5 && average >= 2.5) {
            averageImageView.image = UIImage(named: "star-3")
        }  else if (average < 2.5 && average >= 1.5) {
            averageImageView.image = UIImage(named: "star-2")
        } else {
            averageImageView.image = UIImage(named: "star-1")
        }
    }
}
