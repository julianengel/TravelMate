//
//  SearchVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    let networkingManager = NetworkingManager()
    
    var city: String?
    var language: Languages?
    var type: Types?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTapGesturte()
        
        networkingManager.delegate = self
        
        cityTextField.layer.cornerRadius = 8
        cityTextField.clipsToBounds = true
        
        languageButton.layer.cornerRadius = 8
        languageButton.clipsToBounds = true
        
        typeButton.layer.cornerRadius = 8
        typeButton.clipsToBounds = true
        
        searchButton.layer.cornerRadius = 8
        searchButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "SearchYourTour")
    }

    // MARK: TapGestureRecognizer functions
    func configureTapGesturte() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGestureHandler(tapGesture: UITapGestureRecognizer) {
        cityTextField.resignFirstResponder()
    }
    
    @IBAction func languageDidClick(sender: AnyObject?) {
        let alertController = UIAlertController(title: "Choose language", message: "", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        alertController.addAction(cancelAction)
        
        let polishAction: UIAlertAction = UIAlertAction(title: "Polish", style: .Default) { action -> Void in
            self.languageButton.titleLabel?.text = "Polish"
            self.language = Languages.polish
        }
        alertController.addAction(polishAction)
        
        let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .Default) { action -> Void in
            self.languageButton.titleLabel?.text = "English"
            self.language = Languages.english
        }
        alertController.addAction(englishAction)
        
        let ukrainianAction: UIAlertAction = UIAlertAction(title: "Ukrainian", style: .Default) { action -> Void in
            self.languageButton.titleLabel?.text = "Ukrainian"
            self.language = Languages.ukrainian
        }
        alertController.addAction(ukrainianAction)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func typeDidClick(sender: AnyObject?) {
        let alertController = UIAlertController(title: "Choose type", message: "", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(cancelAction)
        
        let monumentAction: UIAlertAction = UIAlertAction(title: "Monument", style: .Default) { action -> Void in
            self.typeButton.titleLabel?.text = "Monument"
            self.type = Types.monument
        }
        alertController.addAction(monumentAction)
        
        let buildingAction: UIAlertAction = UIAlertAction(title: "Building", style: .Default) { action -> Void in
            self.typeButton.titleLabel?.text = "Building"
            self.type = Types.building
        }
        alertController.addAction(buildingAction)
        
        let landmarkAction: UIAlertAction = UIAlertAction(title: "Landmark", style: .Default) { action -> Void in
            self.typeButton.titleLabel?.text = "Landmark"
            self.type = Types.landmark
        }
        alertController.addAction(landmarkAction)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func performSearch(sender: AnyObject?) {
        networkingManager.performSearchFor(city, language: language, type: type)
    }
}

extension SearchVC: NetworkingManagerDelegate {
    func parsingPlacesCompleted(array: [PlaceModel]) {
        //TODO
    }
}


