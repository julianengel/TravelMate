//
//  PlaceModel.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceModel: NSObject {
    var name = ""
    var placeDescription = ""
    var location: CLLocationCoordinate2D?
    var placeImage: UIImage?
    var audioFileName = ""
}
