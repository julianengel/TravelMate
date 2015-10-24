//
//  PlaceVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 24/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class PlaceVC: BaseViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    
    var place: PlaceModel?
    
    var player:AVAudioPlayer!
    
    let networkingManager = NetworkingManager()


    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let name = place?.name {
            nameLabel.text = name
        }
        if let descriptionText = place?.placeDescription {
            descriptionTextView.text = descriptionText
        }
        
        if let type = place?.type {
            typeLabel.text = Constatnts.setType(type)
        }
        
        if let language = place?.language {
            languageLabel.text = Constatnts.setLanguage(language)
        }
        
        playButton.enabled = false
        
        networkingManager.delegate = self
        networkingManager.downloadAudioForName((place?.audioFileName)!)
        
        setSessionPlayback()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "publishing")
    }

    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func playButtonTouchUp(sender: AnyObject) {
        self.player.play()
    }
    
    func setType(type: Types) -> String {
        switch type {
        case .monument:
            return "Monument"
        case .landmark:
            return "Landmark"
        case .building:
            return "Building"
        }
    }
    
    func setLanguage(language: Languages) -> String {
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

extension PlaceVC: NetworkingManagerDelegate {
    func downloadedDataForAudio(data: NSData) {
        do {
            self.player = try AVAudioPlayer(data: data)
            self.playButton.enabled = true
        } catch _ {
            self.player = nil
            print("nie udalo się :(")
        }
    }
}