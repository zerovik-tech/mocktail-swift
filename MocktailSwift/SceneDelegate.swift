//
//  SceneDelegate.swift
//  Fancy Keys
//
//  Created by Sachin Pandey on 03/05/24.
//  Copyright © 2024 Zerovik Innovations Pvt. Ltd. All rights reserved.
//

import Foundation
import FacebookCore

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // List of known shortcut actions.
    enum ActionType: String {
        case feedback = "Feedback"
       

    }

    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!

  
    func scene(_ scene: UIScene,
                 continue userActivity: NSUserActivity
               )
    {
      ApplicationDelegate.shared.application(.shared, continue: userActivity)
      
      // Rest of implementation...
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("scene method")
        if let userActivity = connectionOptions.userActivities.first,
               userActivity.activityType == NSUserActivityTypeBrowsingWeb
        {
          ApplicationDelegate.shared.application(.shared, continue: userActivity)
        }
        if let shortcutItem = connectionOptions.shortcutItem {
           
           savedShortCutItem = shortcutItem
        }
    }
    
    func scene(_ scene: UIScene,
               openURLContexts URLContexts: Set<UIOpenURLContext>
               )
    {
      guard let url = URLContexts.first?.url else
      {
        return
      }

      // Pass DeepLink URL to iOS SDK
      ApplicationDelegate.shared.application(UIApplication.shared,open: url,sourceApplication: nil,annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }

    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        savedShortCutItem = nil
        if let actionTypeValue = ActionType(rawValue: shortcutItem.type) {
            switch actionTypeValue {
            case .feedback:
                print("feedback")
                if let feedbackURL = URL(string: FEEDBACK_FORM_URL) {
                    if UIApplication.shared.canOpenURL(feedbackURL) {
                            UIApplication.shared.open(feedbackURL, options: [:], completionHandler: nil)
                        }
                }
                              

            }
        }


        return true
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

        print("quick action")
        let handled = handleShortCutItem(shortcutItem: shortcutItem)
        
           completionHandler(handled)

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("scene did became active triggered")
        if savedShortCutItem != nil {
            _ = handleShortCutItem(shortcutItem: savedShortCutItem)
        }
    }
}
