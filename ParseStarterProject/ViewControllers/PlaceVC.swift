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