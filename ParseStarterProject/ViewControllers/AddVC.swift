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
    
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL?
    
    var placeModel = PlaceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.enabled = false
        playButton.enabled = false
        setSessionPlayback()
        askForNotifications()
        checkHeadphones()
        configureTapGesturte()
        send.enabled = false
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
        appDelegate.topVC?.topImageView.image = UIImage(named: "AddVoicePoint")
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
        if let image = placePhoto.image {
            placeModel.placeImage = image
        }
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
                let audioName = NSString(format: "%f%f", (placeModel.location?.latitude)!,(placeModel.location?.longitude)!)
                let pffile = PFFile(data: soundData!)
                let place = PFObject(className: "Places")
                place["name"] = placeModel.name
                place["description"] = placeModel.placeDescription
                place["latitude"] = placeModel.location?.latitude
                place["longitude"] = placeModel.location?.longitude
                place["audioName"] = audioName
                place.saveInBackground()
                let audio = PFObject(className: "Audio")
                audio["Name"] = audioName
                audio["AudioData"] = pffile
                audio.saveInBackground()
            }
            else {
                print("error while creating data from record")
            }
        }
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
            }))
            self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
        error: NSError?) {
            
            if let e = error {
                print("\(e.localizedDescription)")
            }
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
//    func reverseGeocodingFinishedWith(placemark: CLPlacemark) {
//        if let city = placemark.locality where placemark.locality?.characters.count > 0 {
//            cityTextField?.text = city
//        }
//        if let postCode = placemark.postalCode where placemark.postalCode?.characters.count > 0 {
//            postCodeTextField?.text = postCode
//        }
//        if let address = placemark.thoroughfare where placemark.thoroughfare?.characters.count > 0 {
//            streetNameTextField?.text = address
//        }
//        if let addressNumber = placemark.subThoroughfare where placemark.subThoroughfare?.characters.count > 0 {
//            streetNameTextField?.text = (streetNameTextField?.text)! + " " + addressNumber
//        }
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    func gettingLocationFinishedWith(location: CLLocationCoordinate2D) {
        placeModel.location = location
        dismissViewControllerAnimated(true, completion: nil)
        send.enabled = true
    }
}

