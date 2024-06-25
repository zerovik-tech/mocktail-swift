//
//  AppDelegate.swift
//  Focus1
//
//  Created by Karan Chilwal on 27/09/23.
//

import Foundation
import UIKit
import FacebookCore
import RevenueCat
import FirebaseCore
import FirebaseAnalytics
import AppsFlyerLib


class AppDelegate : UIResponder,UIApplicationDelegate, PurchasesDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        

        
        //configure appflyer
        AppsFlyerLib.shared().appsFlyerDevKey = "NbV4N3m54YbZrX6Gp7xypY"
        AppsFlyerLib.shared().appleAppID = "6477149814"
        //  Set isDebug to true to see AppsFlyer debug logs
        AppsFlyerLib.shared().isDebug = true
        
        
        FirebaseApp.configure()
        
        
        
        Purchases.shared.delegate = self
        let instanceId = Analytics.appInstanceID();
        if let unwrapped = instanceId {
            print("Current Instance Id -> ",unwrapped);
            print("Setting Attributes");
            Purchases.shared.attribution.setFirebaseAppInstanceID(unwrapped)
        } else {
            print("No Instance ID found!!")
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    
        AppsFlyerLib.shared().handleOpen(url, options: options)

        
        return true
    }
    
    //connects to SceneDelegate
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
            sceneConfiguration.delegateClass = SceneDelegate.self
            return sceneConfiguration
        }
    
    func application(_ application: UIApplication,
                       continue userActivity: NSUserActivity,
                       restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
                     ) -> Bool
    {
      ApplicationDelegate.shared.application(application, continue: userActivity)
        
      AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
      
      // Rest of implementation...
      
      return true
    }
    
}

