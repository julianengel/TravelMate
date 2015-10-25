/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKCoreKit


// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let beaconManager = BeaconManager()
    
    var topVC: TopVC?
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        customizeAppearance()
        
        Parse.setApplicationId("Us4UivwQoKxsHuJCX38ysFu7UVAUFtBNdRlkl0kx",
            clientKey: "9ankNDZNa8LUlaU0QTy6F3JnX6BxAfyKAJxXMp73")
        
        beaconManager.configureManager()
        beaconManager.delegate = self
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        topVC = window!.rootViewController as? TopVC
        
                if #available(iOS 8.0, *) {
                    let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
                    let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
                    application.registerUserNotificationSettings(settings)
                    application.registerForRemoteNotifications()
                } else {
                    let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
                    application.registerForRemoteNotificationTypes(types)
                }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
}

func customizeAppearance() {
    UINavigationBar.appearance().barTintColor = CustomColors.blue
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBar.appearance().barTintColor = CustomColors.orange
    UITabBar.appearance().tintColor = UIColor.whiteColor()
}


func sendLocalNotificationWithMessage(message: String) {
    let notificationAlert = UILocalNotification()
    if #available(iOS 8.2, *) {
        notificationAlert.alertTitle = "You entered TravelVoice region"
        notificationAlert.alertBody = message
        notificationAlert.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notificationAlert)
    } else {
        // Fallback on earlier versions
    }
}

extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

extension AppDelegate: BeaconManagerDelegate {
    func found(beacon: String) {
        switch beacon {
        case "1": sendLocalNotificationWithMessage("Check TravelVoice! You're near something interesting!")
        case "2": break //sendLocalNotificationWithMessage("bb")
        case "3": break //sendLocalNotificationWithMessage("cc")
        case "4": break //sendLocalNotificationWithMessage("dd")
        case "5": break //sendLocalNotificationWithMessage("ee")
        case "6": break //sendLocalNotificationWithMessage("ff")
        case "enterPieB": sendLocalNotificationWithMessage("You entered area with TravelVoice!")
        default: break
        }
    }
}