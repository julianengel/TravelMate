//
//  ListVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import MGSwipeTableCell
import Parse
import MBProgressHUD

class ListVC: BaseViewController {
    
    var places: [PlaceModel] = []
    let networkingManager = NetworkingManager()
    
    var cell: PlaceTVC!
    
    weak var tableView: UITableView!
    var player: AVAudioPlayer?
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networkingManager.delegate = self
        
        let cellNib = UINib(nibName: CellsIdentifiers.placeTVC, bundle: nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: CellsIdentifiers.placeTVC)
        loadData(nil)
        refreshControl.addTarget(self, action: "loadData:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "Trending tours")
    }
    
    func loadData(sender: AnyObject?) {
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
        
        cell.rightButtons = [
            MGSwipeButton(title: "", icon: UIImage(named: "piec"), backgroundColor: CustomColors.blue, callback: { (_) -> Bool in
                let queue = PFQuery(className: "Places")
                print(self.places[indexPath.row].audioFileName)
                queue.whereKey("audioName", equalTo: self.places[indexPath.row].audioFileName)
                queue.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        var count = object?.objectForKey("count") as! Int
                        var rating = object?.objectForKey("rating") as! Float
                        count++
                        rating = rating + 5
                        object!["count"] = count
                        object!["rating"] = rating
                        object!.saveInBackground()
                    }
                })
                return true
            })
            ,MGSwipeButton(title: "", icon: UIImage(named: "cztery"), backgroundColor: CustomColors.blue, callback: { (_) -> Bool in
                let queue = PFQuery(className: "Places")
                queue.whereKey("audioName", equalTo: self.places[indexPath.row].audioFileName)
                queue.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        var count = object?.objectForKey("count") as! Int
                        var rating = object?.objectForKey("rating") as! Float
                        count++
                        rating = rating + 4
                        object!["count"] = count
                        object!["rating"] = rating
                        object!.saveInBackground()
                    }
                })
                return true
            })
            ,MGSwipeButton(title: "", icon: UIImage(named: "trzy"), backgroundColor: CustomColors.blue, callback: { (_) -> Bool in
                let queue = PFQuery(className: "Places")
                queue.whereKey("audioName", equalTo: self.places[indexPath.row].audioFileName)
                queue.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        var count = object?.objectForKey("count") as! Int
                        var rating = object?.objectForKey("rating") as! Float
                        count++
                        rating = rating + 3
                        object!["count"] = count
                        object!["rating"] = rating
                        object!.saveInBackground()
                    }
                })
                return true
            })
            ,MGSwipeButton(title: "", icon: UIImage(named: "dwa"), backgroundColor: CustomColors.blue, callback: { (_) -> Bool in
                let queue = PFQuery(className: "Places")
                queue.whereKey("audioName", equalTo: self.places[indexPath.row].audioFileName)
                queue.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        var count = object?.objectForKey("count") as! Int
                        var rating = object?.objectForKey("rating") as! Float
                        count++
                        rating = rating + 2
                        object!["count"] = count
                        object!["rating"] = rating
                        object!.saveInBackground()
                    }
                })
                return true
            })
            ,MGSwipeButton(title: "", icon: UIImage(named: "jeden"), backgroundColor: CustomColors.blue, callback: { (_) -> Bool in
                let queue = PFQuery(className: "Places")
                queue.whereKey("audioName", equalTo: self.places[indexPath.row].audioFileName)
                queue.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        var count = object?.objectForKey("count") as! Int
                        var rating = object?.objectForKey("rating") as! Float
                        count++
                        rating = rating + 1
                        object!["count"] = count
                        object!["rating"] = rating
                        object!.saveInBackground()
                    }
                })
                return true
            })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
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
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = NSLocalizedString("Loading", comment: "HUD Loading")
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
    func showCompletionHUDWithText(text: String, positive: Bool) {
        let doneNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if positive {
            doneNotification.customView = UIImageView(image: UIImage(named: "Checkmark"))
            doneNotification.labelText = NSLocalizedString(text, comment: "HUD Loading")
        } else {
            doneNotification.customView = UIImageView(image: UIImage(named: "Failed"))
            doneNotification.labelText = NSLocalizedString("Failed", comment: "HUD Loading")
        }
        doneNotification.mode = MBProgressHUDMode.CustomView
        doneNotification.show(true)
        doneNotification.hide(true, afterDelay: 2)
    }
}

extension ListVC: NetworkingManagerDelegate {
    func parsingPlacesCompleted(array: [PlaceModel]) {
        places = array
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    func downloadedDataForAudio(data: NSData) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.showCompletionHUDWithText("Completed", positive: true)
        cell!.audioData = data
        cell!.downloaded = true
        cell?.downloadImage.hidden = true
        cell?.speakerImage.hidden = false
    }
}