//
//  NewsVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewsVC: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    let networkingManager = NetworkingManager()
    
    var places = [PlaceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        navigationController
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        networkingManager.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "Searchingresults")
        networkingManager.downlaodAllPlaces()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
//        switch annotations.count {
//        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
//        case 1:
//            let annotation = annotations[annotations.count - 1]
//            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
//        default:
//            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
//            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
//            
//            for annotation in annotations {
//                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
//                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
//                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
//                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
//            }
//            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2, longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
//            
//            let extraSpace = 1.1
//            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace, longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
//            
//            region = MKCoordinateRegionMake(center, span)
//        default:
//            return
//        }
        return mapView.regionThatFits(region)
    }
}


extension NewsVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("Everything ok")
                }
            }
        }
    }
}

extension NewsVC: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PlaceModel {
            let identifier = "Location"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                annotationView.enabled = true
                annotationView.canShowCallout = true
                annotationView.animatesDrop = false
                annotationView.pinColor = .Green
                annotationView.tintColor = UIColor(white: 0.0, alpha: 0.5)
                
//                let rightButton = UIButton.
//                    buttonWithType(.DetailDisclosure)
//                
//                rightButton.addTarget(self,
//                    action: Selector("showLocationDetails:"),
//                    forControlEvents: .TouchUpInside)
                
//                annotationView.rightCalloutAccessoryView = rightButton
            } else {
                annotationView.annotation = annotation
            }
            
//            let button = annotationView.rightCalloutAccessoryView as! UIButton
//            if let index = find(locations, annotation as! Location) {
//                button.tag = index
//            }
            return annotationView
        }
        return nil
    }
}

extension NewsVC: NetworkingManagerDelegate {
    func parsingPlacesCompleted(array: [PlaceModel]) {
        places = array
        self.mapView.addAnnotations(self.places)
        let region = regionForAnnotations(places)
        mapView.setRegion(region, animated: true)
        print(places)
    }
}
