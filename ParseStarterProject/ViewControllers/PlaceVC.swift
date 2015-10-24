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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var place: PlaceModel?
    
    var player:AVAudioPlayer!
    
    let networkingManager = NetworkingManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(place!.name)
        
        networkingManager.delegate = self
        networkingManager.downloadAudioForName((place?.audioFileName)!)
        
        setSessionPlayback()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlaceVC: NetworkingManagerDelegate {
    func downloadedDataForAudio(data: NSData) {
        do {
            self.player = try AVAudioPlayer(data: data)
        } catch _ {
            self.player = nil
            print("nie udalo się :(")
        }
        
        self.player.play()
    }
}