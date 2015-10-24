//
//  NetworkingManager.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

@objc protocol NetworkingManagerDelegate: class {
    optional func parsingPlacesCompleted(objects: [PlaceModel])
    
    optional func downloadedDataForAudio(data: NSData)
}

class NetworkingManager: NSObject {

    weak var delegate: NetworkingManagerDelegate?
    
    func downlaodAllPlaces() {
        let queue = PFQuery(className: "Places")
        queue.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, _: NSError?) -> Void in
            if objects?.count > 0 {
                var array:[PlaceModel] = []
                for (_,element) in (objects?.enumerate())! {
                    let place = PlaceModel()
                    place.name = element.objectForKey("name") as! String
                    place.placeDescription = element.objectForKey("description") as! String
                    place.audioFileName = element.objectForKey("audioName") as! String
                    array.append(place)
                }
                self.delegate?.parsingPlacesCompleted!(array)
            }
        }
    }
    
    func downloadAudioForName(name: String) {
        let queue = PFQuery(className: "Audio")
        queue.whereKey("Name", equalTo: name)
        queue.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                let data = object?.objectForKey("AudioData") as! PFFile
                
                data.getDataInBackgroundWithBlock({ (audioData, error) -> Void in
                    self.delegate?.downloadedDataForAudio!(audioData!)
                })
            }
        }
    }
}
