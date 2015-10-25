//
//  Constants.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

enum Languages: Int {
    case polish = 0
    case english
    case ukrainian
}

enum Types: Int {
    case monument = 0
    case building
    case landmark
}

struct CustomColors {
    static let orange = UIColor(red: 251/255.0, green: 155/255.0, blue: 39/255.0, alpha: 1.0)
    static let blue = UIColor(red: 73/255.0, green: 100/255.0, blue: 123/255.0, alpha: 1.0)
}

class Constatnts: NSObject {
    class func setType(type: Types) -> String {
        switch type {
        case .monument:
            return "Monument"
        case .landmark:
            return "Landmark"
        case .building:
            return "Building"
        }
    }
    
    class func setLanguage(language: Languages) -> String {
        switch language {
        case .polish:
            return "Polish"
        case .english:
            return "English"
        case .ukrainian:
            return "Ukrainian"
        }
    }
}

struct CellsIdentifiers {
    static let placeTVC = "PlaceTVC"
}

struct SeguesIdentifiers {
    static let mapSegue = "MapSegue"
    static let placeSegue = "PlaceSegue"
}