//
//  BeaconVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 25/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
import MBProgressHUD

class BeaconVC: UIViewController {

    //50.07aa19.95
    
    var player: AVAudioPlayer?
    let networkingManager = NetworkingManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSessionPlayback()
        networkingManager.delegate = self

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func xPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func playButtonDidClick(sender: AnyObject) {
        networkingManager.downloadAudioForName("50.07aa19.95")
    }
}

extension BeaconVC: NetworkingManagerDelegate {
    func downloadedDataForAudio(data: NSData) {
        do {
            self.player = try AVAudioPlayer(data: data)
            self.player?.play()
        } catch _ {
            self.player = nil
            print("nie udalo się :(")
        }
    }
}
