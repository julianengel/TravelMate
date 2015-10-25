//
//  AddVC.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import MBProgressHUD

class AddVC: BaseViewController {
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var addPhotoButton: UIButton!
    
    @IBOutlet var placePhoto: UIImageView!
    
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var geo: UIButton!
    
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL?
    
    var placeModel = PlaceModel()
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteAllRecordings()
        
        stopButton.enabled = false
        playButton.enabled = false
        setSessionPlayback()
        askForNotifications()
        checkHeadphones()
        configureTapGesturte()
        self.checkIfDataValid()

        
        send.layer.cornerRadius = 8
        send.clipsToBounds = true

        nameTextField.layer.cornerRadius = 8
        nameTextField.clipsToBounds = true

        languageButton.layer.cornerRadius = 8
        languageButton.clipsToBounds = true

        typeButton.layer.cornerRadius = 8
        typeButton.clipsToBounds = true

        geo.layer.cornerRadius = 8
        geo.clipsToBounds = true
    }
    
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            recorder.updateMeters()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.topVC?.topImageView.image = UIImage(named: "Add voice point")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SeguesIdentifiers.mapSegue {
            let controller = segue.destinationViewController as! MapVC
            controller.delegate = self
        }
    }
    
    // MARK: TapGestureRecognizer functions
    
    func configureTapGesturte() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGestureHandler(tapGesture: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func removeAll(sender: AnyObject) {
        deleteAllRecordings()
        self.recordButton.enabled = true
    }
    
    @IBAction func record(sender: UIButton) {
        
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)            
            return
        }
        
        if recorder != nil && recorder.recording {
            print("pausing")
            recorder.pause()
            recordButton.setTitle("Continue", forState:.Normal)
        } else {
            print("recording")
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(false)
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        print("stop")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", forState:.Normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.enabled = true
            stopButton.enabled = false
            recordButton.enabled = true
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func play(sender: UIButton) {
        play()
    }
    
    @IBAction func addPhotot(sender: UIButton) {
        
    }
    
    @IBAction func send(sender: AnyObject) {
        if let text = nameTextField.text {
            placeModel.name = text
        }
        if let text = descriptionTextView.text {
            placeModel.placeDescription = text
        }
//        if let image = placePhoto.image {
//            placeModel.placeImage = image
//        }
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(paths)
        while let file = files?.nextObject() {
            print(file)
                    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let soundFileURL = documentsDirectory.URLByAppendingPathComponent(file as! String)

            let soundData = NSData(contentsOfURL: soundFileURL)
            // .contentsOfFile: soundFileURL options: 0 error: &errorPtr)
            if soundData != nil {
                // Do something
                print("create pffile")
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.Indeterminate
                loadingNotification.labelText = NSLocalizedString("Loading", comment: "HUD Loading")
                let audioName = NSString(format: "%.2faa%.2f", (placeModel.location?.latitude)!,(placeModel.location?.longitude)!)
                let pffile = PFFile(data: soundData!)
                let place = PFObject(className: "Places")
                place["name"] = placeModel.name
                place["description"] = placeModel.placeDescription
                place["latitude"] = placeModel.location?.latitude
                place["longitude"] = placeModel.location?.longitude
                place["audioName"] = audioName
                place["type"] = placeModel.type?.rawValue
                place["language"] = placeModel.language?.rawValue
                place["city"] = placeModel.city
                place["rating"] = 0
                place["count"] = 0
                
                let defaultACL = PFACL()
                defaultACL.setPublicReadAccess(true)
                defaultACL.setPublicWriteAccess(true)
                place.ACL = defaultACL
                
                let facebookCredentials = NSUserDefaults.standardUserDefaults()
                place["fbID"] = facebookCredentials.objectForKey("fbID") as! String
                
                print(placeModel.name,placeModel.placeDescription,placeModel.location?.latitude,placeModel.location?.longitude,audioName,placeModel.type?.rawValue,placeModel.language?.rawValue,placeModel.city)
                
                place.saveInBackground()
                let audio = PFObject(className: "Audio")
                audio["Name"] = audioName
                audio["AudioData"] = pffile
                audio.saveInBackgroundWithBlock({ (completed: Bool, error: NSError?) -> Void in
                    if error == nil {
                        if completed {
                            print("completed")
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            self.showCompletionHUDWithText("Completed", positive: true)
                        } else {
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            self.showCompletionHUDWithText("Failed", positive: false)
                        }
                    } else {
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.showCompletionHUDWithText("Failed", positive: false)
                    }
                })
                return
            }
            else {
                print("error while creating data from record")
            }
        }
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
    
    func play() {
        
        var url:NSURL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        print(currentFileName)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
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
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
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
    
    func deleteAllRecordings() {
        let docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            let files = try fileManager.contentsOfDirectoryAtPath(docsDir)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix("m4a")
            })
            for var i = 0; i < recordings.count; i++ {
                let path = docsDir + "/" + recordings[i]
                
                print("removing \(path)")
                do {
                    try fileManager.removeItemAtPath(path)
                } catch let error as NSError {
                    NSLog("could not remove \(path)")
                    print(error.localizedDescription)
                }
            }
            
        } catch let error as NSError {
            print("could not get contents of directory at \(docsDir)")
            print(error.localizedDescription)
        }
        self.checkIfDataValid()

    }
    
    func askForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"background:",
            name:UIApplicationWillResignActiveNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"foreground:",
            name:UIApplicationWillEnterForegroundNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"routeChange:",
            name:AVAudioSessionRouteChangeNotification,
            object:nil)
    }
    
    func background(notification:NSNotification) {
        print("background")
    }
    
    func foreground(notification:NSNotification) {
        print("foreground")
    }
    
    func routeChange(notification:NSNotification) {
        print("routeChange \(notification.userInfo)")
        
        if let userInfo = notification.userInfo {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                switch AVAudioSessionRouteChangeReason(rawValue: reason)! {
                case AVAudioSessionRouteChangeReason.NewDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.OldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.CategoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.Override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.WakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.Unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.NoSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.RouteConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func checkHeadphones() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
        }
    }
 
    @IBAction func languageDidClick(sender: AnyObject?) {
        nameTextField.resignFirstResponder()
        let alertController = UIAlertController(title: "Choose language", message: "", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            self.checkIfDataValid()
        }
        
        alertController.addAction(cancelAction)
        
        let polishAction: UIAlertAction = UIAlertAction(title: "Polish", style: .Default) { action -> Void in
           // self.languageButton.titleLabel?.text = "Polish"
            self.languageButton.setTitle("Polish", forState: .Normal)
            self.placeModel.language = Languages.polish
            self.checkIfDataValid()
        }
        alertController.addAction(polishAction)
        
        let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .Default) { action -> Void in
            self.languageButton.setTitle("English", forState: .Normal)
           // self.languageButton.titleLabel?.text = "English"
            self.placeModel.language = Languages.english
            self.checkIfDataValid()
        }
        alertController.addAction(englishAction)
        
        let ukrainianAction: UIAlertAction = UIAlertAction(title: "Ukrainian", style: .Default) { action -> Void in
            self.languageButton.setTitle("Ukrainian", forState: .Normal)
          //  self.languageButton.titleLabel?.text = "Ukrainian"
            self.placeModel.language = Languages.ukrainian
            self.checkIfDataValid()
        }
        alertController.addAction(ukrainianAction)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func typeDidClick(sender: AnyObject?) {
        nameTextField.resignFirstResponder()

        let alertController = UIAlertController(title: "Choose type", message: "", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            self.checkIfDataValid()
        }
        alertController.addAction(cancelAction)
        
        let monumentAction: UIAlertAction = UIAlertAction(title: "Monument", style: .Default) { action -> Void in
            self.typeButton.setTitle("Monument", forState: .Normal)
            //self.typeButton.titleLabel?.text = "Monument"
            self.placeModel.type = Types.monument
            self.checkIfDataValid()
        }
        alertController.addAction(monumentAction)
        
        let buildingAction: UIAlertAction = UIAlertAction(title: "Building", style: .Default) { action -> Void in
            self.typeButton.setTitle("Building", forState: .Normal)
//            self.typeButton.titleLabel?.text = "Building"
            self.placeModel.type = Types.building
            self.checkIfDataValid()
        }
        alertController.addAction(buildingAction)
        
        let landmarkAction: UIAlertAction = UIAlertAction(title: "Landmark", style: .Default) { action -> Void in
//            self.typeButton.titleLabel?.text = "Landmark"l
            self.typeButton.setTitle("Landmark", forState: .Normal)

            self.placeModel.type = Types.landmark
            self.checkIfDataValid()
        }
        alertController.addAction(landmarkAction)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func checkIfDataValid() {
        if (placeModel.type != nil && placeModel.language != nil && placeModel.city != nil && nameTextField.text != "" && descriptionTextView.text != "") {
            send.enabled = true
        } else {
            send.enabled = false
        }
    }
}

// MARK: AVAudioRecorderDelegate
extension AddVC : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool) {
            print("finished recording \(flag)")
            stopButton.enabled = false
            playButton.enabled = true
            recordButton.setTitle("Record", forState:.Normal)
            
            // iOS8 and later
            let alert = UIAlertController(title: "Recorder",
                message: "Finished Recording",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                print("keep was tapped")
                self.recordButton.enabled = false
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                print("delete was tapped")
                self.recorder.deleteRecording()
                self.checkIfDataValid()
            }))
            self.presentViewController(alert, animated:true, completion:nil)
    }
}

// MARK: AVAudioPlayerDelegate
extension AddVC : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
        recordButton.enabled = true
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}

extension AddVC: MapVCDelegate {
    func gettingLocationFinishedWith(location: CLLocationCoordinate2D, andCity city: String) {
        placeModel.location = location
        placeModel.city = city
        dismissViewControllerAnimated(true, completion: nil)
        send.enabled = true
    }
}

