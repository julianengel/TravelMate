//
//  PlaceTVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PlaceTVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    
    @IBOutlet weak var jon: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
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
        jon.layer.cornerRadius = jon.frame.size.width/2
        jon.clipsToBounds = false
        nameLabel.text = place.name
        
        print(place)
        typeLabel.text = Constatnts.setType(place.type!)
        languageLabel.text = Constatnts.setLanguage(place.language!)
    }
}
