//
//  AppDelegate.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/12/25.
//

import SwiftUI

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(_ application: UIApplication, 
                   configurationForConnecting connectingSceneSession: UISceneSession, 
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(
      name: "Default",
      sessionRole: connectingSceneSession.role
    )
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }
}
#endif
