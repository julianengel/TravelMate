//
//  PlaceModel.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PlaceModel: NSObject, MKAnnotation {
    
    var name = ""
    var placeDescription = ""
    var location: CLLocationCoordinate2D?
    var placeImage: UIImage?
    var audioFileName = ""
    
    var type: Types?
    var language: Languages?
    var city: String?
    
    var rating: Float?
    var count: Int?
    
    var facebookID: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake((location?.latitude)!, (location?.longitude)!)
    }
    
    var title: String? {
        if name.isEmpty {
            return "(No Description)"
        } else {
            return name
        }
    }
    
    var subtitle: String? {
        return ""
    }
}
