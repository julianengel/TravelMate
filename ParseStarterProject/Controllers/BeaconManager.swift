//
//  BeaconManager.swift
//  Simple Beacon App
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Błażej Chwiećko. All rights reserved.
//

import UIKit
import CoreLocation

let UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
let icyMarshmallowB:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 57786, minor: 47178)
let mintCocktailB:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 34854, minor: 20994)
let blueberryPieB:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 26368, minor: 24349)

let icyMarshmallowJ:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 21576, minor: 3917)
let mintCocktailJ:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 8778, minor: 39716)
let blueberryPieJ:(major: CLBeaconMajorValue, minor: CLBeaconMinorValue) = (major: 4483, minor: 58128)

protocol BeaconManagerDelegate: class {
    func found(beacon: String)
}

class BeaconManager: NSObject {
    let locationManager = CLLocationManager()
    
    let beaconIcyMarshmallowB = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: icyMarshmallowB.major, minor: icyMarshmallowB.minor, identifier: "icyB")
    let beaconMintCocktailB = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: mintCocktailB.major, minor: mintCocktailB.minor, identifier: "mintB")
    let beaconBlueberryPieB = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: blueberryPieB.major, minor: blueberryPieB.minor, identifier: "blueberryB")
    
    let beaconIcyMarshmallowJ = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: icyMarshmallowJ.major, minor: icyMarshmallowJ.minor, identifier: "icyJ")
    let beaconMintCocktailJ = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: mintCocktailJ.major, minor: mintCocktailJ.minor, identifier: "mintJ")
    let beaconBlueberryPieJ = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUID)!, major: blueberryPieJ.major, minor: blueberryPieJ.minor, identifier: "blueberryJ")
    
    weak var delegate: BeaconManagerDelegate?
    
    func configureManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        locationManager.startMonitoringForRegion(beaconIcyMarshmallowB)
        locationManager.startMonitoringForRegion(beaconMintCocktailB)
        locationManager.startMonitoringForRegion(beaconBlueberryPieB)
        
        locationManager.startRangingBeaconsInRegion(beaconIcyMarshmallowJ)
        locationManager.startRangingBeaconsInRegion(beaconMintCocktailJ)
        locationManager.startRangingBeaconsInRegion(beaconBlueberryPieJ)
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region == beaconBlueberryPieB {
            delegate?.found("enterPieB")
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
       // print("aa")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        //print(beacons)
        if beacons.count == 0 {
            return
        }
        for (_,element) in beacons.enumerate() {
            if element.proximityUUID.UUIDString.lowercaseString == beaconIcyMarshmallowB.proximityUUID.UUIDString.lowercaseString && element.minor == beaconIcyMarshmallowB.minor {
                delegate?.found("1")
            }
            else if element.proximityUUID.UUIDString.lowercaseString == beaconMintCocktailB.proximityUUID.UUIDString.lowercaseString && element.minor == beaconMintCocktailB.minor {
                delegate?.found("2")
            }  else if element.proximityUUID.UUIDString.lowercaseString == beaconBlueberryPieB.proximityUUID.UUIDString.lowercaseString && element.minor == beaconBlueberryPieB.minor {
                delegate?.found("3")
            } else if element.proximityUUID.UUIDString.lowercaseString == beaconIcyMarshmallowJ.proximityUUID.UUIDString.lowercaseString && element.minor == beaconIcyMarshmallowJ.minor {
                delegate?.found("4")
            } else if element.proximityUUID.UUIDString.lowercaseString == beaconMintCocktailJ.proximityUUID.UUIDString.lowercaseString && element.minor == beaconMintCocktailJ.minor  && element.proximity == CLProximity.Immediate {
                delegate?.found("5")
            }  else if element.proximityUUID.UUIDString.lowercaseString == beaconBlueberryPieJ.proximityUUID.UUIDString.lowercaseString && element.minor == beaconBlueberryPieJ.minor {
                delegate?.found("6")
            }
        }
    }
}
