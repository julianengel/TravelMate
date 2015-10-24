//
//  ListVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ListVC: BaseViewController {

    var places: [PlaceModel] = []
    let networkingManager = NetworkingManager()
    
    weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networkingManager.delegate = self
        networkingManager.downlaodAllPlaces()
        
        let cellNib = UINib(nibName: CellsIdentifiers.placeTVC, bundle: nil)
        tableView!.registerNib(cellNib, forCellReuseIdentifier: CellsIdentifiers.placeTVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "famousetours")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.placeSegue {
            let controller = segue.destinationViewController as! PlaceVC
            let indexPath = sender as! Int
            controller.place = places[indexPath]
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
        performSegueWithIdentifier(SeguesIdentifiers.placeSegue, sender: indexPath.row)
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
}