//
//  MapVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import CoreLocation

protocol MapVCDelegate: class {
    //func reverseGeocodingFinishedWith(placemark: CLPlacemark)
    func gettingLocationFinishedWith(location: CLLocationCoordinate2D, andCity: String)
}

class MapVC: UIViewController {
    
    var currentPickedLocation: CLLocation?
    
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var doneButton: UIButton?
    weak var delegate: MapVCDelegate?
    
    var placemark: CLPlacemark?
    
    var city: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        mapView.delegate = self
        congifureLongPress()

        doneButton!.sizeToFit()
        doneButton!.titleEdgeInsets = UIEdgeInsetsMake(0, -doneButton!.imageView!.frame.size.width, 0, doneButton!.imageView!.frame.size.width)
        doneButton!.imageEdgeInsets = UIEdgeInsetsMake(0, doneButton!.titleLabel!.frame.size.width, 0, -doneButton!.titleLabel!.frame.size.width)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func congifureLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPress.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longPress)
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let point = MKPointAnnotation()
        point.coordinate = touchMapCoordinate
        currentPickedLocation = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        for (_,element) in mapView.annotations.enumerate() {
            mapView.removeAnnotation(element)
        }
        mapView.addAnnotation(point)
    }
    
    func performReverseGeocodeLocation() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = NSLocalizedString("Loading", comment: "HUD Loading")
        geocoder.reverseGeocodeLocation(currentPickedLocation!, completionHandler: {
            placemarks, error in
            if error == nil && !placemarks!.isEmpty && placemarks!.last?.locality != nil {
                if let placemark = placemarks!.last {
                    self.placemark = placemark
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.showCompletionHUDWithText("Completed", positive: true)
                }
            } else {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.showCompletionHUDWithText("Failed", positive: false)
            }
        })
    }
    
    @IBAction func cancelButtonDidClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneButtonDidClick(sender: AnyObject) {
        //delegate?.gettingLocationFinishedWith(currentPickedLocation!.coordinate)
        performReverseGeocodeLocation()
    }
    
    func showCompletionHUDWithText(text: String, positive: Bool) {
        let doneNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if positive {
            doneNotification.customView = UIImageView(image: UIImage(named: "Checkmark"))
            doneNotification.labelText = NSLocalizedString(text, comment: "HUD Loading")
            doneNotification.delegate = self
        } else {
            doneNotification.customView = UIImageView(image: UIImage(named: "Failed"))
            doneNotification.labelText = NSLocalizedString("Failed", comment: "HUD Loading")
        }
        doneNotification.mode = MBProgressHUDMode.CustomView
        doneNotification.show(true)
        doneNotification.hide(true, afterDelay: 2)
    }
}


extension MapVC: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotaionView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "selected")
        pinAnnotaionView.animatesDrop = true
        pinAnnotaionView.image = UIImage(named: "location_map")
        pinAnnotaionView.pinColor = MKPinAnnotationColor.Green
        pinAnnotaionView.enabled = false
        doneButton?.enabled = true
        return pinAnnotaionView
    }
}

extension MapVC: MBProgressHUDDelegate {
    func hudWasHidden(hud: MBProgressHUD!) {
        self.delegate?.gettingLocationFinishedWith(currentPickedLocation!.coordinate, andCity: (placemark?.locality)!)
//        self.delegate?.reverseGeocodingFinishedWith(self.placemark!)
    }
}
