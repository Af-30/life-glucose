//
//  AppDelegate.swift
//  Life Glucose
//
//  Created by grand ahmad on 04/04/1443 AH.
//

import UIKit
import Firebase
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{
  


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let center = UNUserNotificationCenter.current()
        let option : UNAuthorizationOptions = [.sound , .alert ]
        center.requestAuthorization(options: option) {
            (sucess, error) in
            if error != nil {
                
            }
        }
        center.delegate = self 
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
//        let db = Firestore.firestore()
//        db.collection("doctors").addDocument(data: ["name": "azef", "id": 123]) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            print("ADDED")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

