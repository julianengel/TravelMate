//
//  Constants.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

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