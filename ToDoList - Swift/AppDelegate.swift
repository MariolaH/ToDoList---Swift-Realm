//
//  AppDelegate.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/18/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //This is the first thing that happens and this happens before the viewDidLoad inside the inital VC
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //This happens when your app disappears off the screen, when home button is pressed or open different app. App is no longer visible and it's entered the background
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //This tends to get triggered when something happens to the phone while the app is open ie. in the foreground
        //method where you can do something to prevent the user losing data
    }
    
    
}

