//
//  ListVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class ListVC: BaseViewController {
    
    var places: [PlaceModel] = []
    let networkingManager = NetworkingManager()
    
    var cell: PlaceTVC!
    
    weak var tableView: UITableView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networkingManager.delegate = self
        
        let cellNib = UINib(nibName: CellsIdentifiers.placeTVC, bundle: nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: CellsIdentifiers.placeTVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "famousetours")
        networkingManager.downlaodAllPlaces()
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
}

extension ListVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifiers.placeTVC , forIndexPath: indexPath) as! PlaceTVC
        cell.configureCell(places[indexPath.row])
        //print(places[0].name)
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = places[indexPath.row]
        cell = tableView.cellForRowAtIndexPath(indexPath) as? PlaceTVC
        if !cell!.downloaded {
            networkingManager.downloadAudioForName(place.audioFileName)
            cell?.selected = false
        } else {
            if (cell!.audioData != nil) {
                setSessionPlayback()
                do {
                    self.player = try AVAudioPlayer(data: cell!.audioData!)
                    self.player?.play()
                } catch _ {
                    self.player = nil
                    print("nie udalo się :(")
                }
            }
            cell?.selected = false
        }
        //  performSegueWithIdentifier(SeguesIdentifiers.placeSegue, sender: indexPath.row)
    }
}

extension ListVC: NetworkingManagerDelegate {
    func parsingPlacesCompleted(array: [PlaceModel]) {
        places = array
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
        //print(places)
    }
    func downloadedDataForAudio(data: NSData) {
        cell!.audioData = data
        cell!.downloaded = true
        cell?.downloadImage.hidden = true
        cell?.speakerImage.hidden = false
    }
}