//
//  AppDelegate.swift
//  Umaass
//
//  Created by Hesam on 6/31/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseAnalytics
import Fabric
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import Siren
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    // ---------------- fetch language -----------------
        let languageRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Setting")
        languageRequest.returnsObjectsAsFaults = false
        do{let results = try context.fetch(languageRequest)
            if (results.count) > 0 {
                for result in results as! [NSManagedObject] {
                    if let language = result.value(forKey: "appLanguage") as? String, let langCode = result.value(forKey: "languageCode") as? String {
                        appLang = language
                        resourceKey = langCode
                        print("language(appLang): \(String(describing: appLang))")
                        print("languageCode(resourceKey): \(String(describing: resourceKey))")
                    }}}}catch{}
        print("resourceKey",resourceKey)
        
        self.ChangeLayout()
       // GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        FirebaseApp.configure()
//        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
    // ---------------------------------------
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        self.setupSiren()
        return true
    }
    
// ----------------- language ----------------
    func ChangeLayout(){
        if resourceKey == "ar" || resourceKey == "ckb" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    
    

    // ----------------- didRegister notificationSettings -------------------------------------
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Hooray! I'm registered!")
        Messaging.messaging().subscribe(toTopic: "/topics/nutriewell_live")
    }
    
    // ----------------- didReceiveRemoteNotification -------------------------------------
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("dddd", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func setupSiren() {
         let siren = Siren.shared
        siren.rulesManager = RulesManager(majorUpdateRules: .critical,
           minorUpdateRules: .critical,
           patchUpdateRules: .critical,
           revisionUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force))
                  siren.wail { results in
                      switch results {
                      case .success(let updateResults):
                          print("AlertAction ", updateResults.alertAction)
                          print("Localization ", updateResults.localization)
                          print("Model ", updateResults.model)
                          print("UpdateType ", updateResults.updateType)
                          print(updateResults.model.version)
                       
                      case .failure(let error):
                          print(error.localizedDescription)
                      }
                  }
           }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Umaass")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


let appDelegate   = UIApplication.shared.delegate as! AppDelegate
let context       = appDelegate.persistentContainer.viewContext




@available(iOS 10, *)
extension AppDelegate  {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("tap on on forground app",userInfo)
        completionHandler()
    }
    
}

    extension AppDelegate {
            func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
                print("Firebase registration token: \(fcmToken)")
                  deviceTokenn = fcmToken
                Messaging.messaging().subscribe(toTopic: "/topics/nutriewell_live")
                Messaging.messaging().shouldEstablishDirectChannel = true
            }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//            deviceTokenn = token
            print("device token",token )
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print(error)
        }
        
        func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
            print("Received data message: \(remoteMessage.appData)")
        }
        
}

//extension UITextField {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        //if UserDefaults.languageCode == "ar" {
//        if textAlignment == .natural {
//            self.textAlignment = .right
//        }
//        //}
//    }
//}
//
//extension UILabel {
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        //if UserDefaults.languageCode == "ar" {
//        if textAlignment == .natural {
//            self.textAlignment = .right
//        }
//        //}
//    }
//}
