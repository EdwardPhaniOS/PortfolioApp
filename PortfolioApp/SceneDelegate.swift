//
//  AppDelegate.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/12/25.
//

import SwiftUI

#if os(iOS)
class SceneDelegate: NSObject, UIWindowSceneDelegate {
 
  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    guard let url = URL(string: shortcutItem.type) else {
      completionHandler(false)
      return
    }
    
    windowScene.open(url, options: nil, completionHandler: completionHandler)
  }
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    if let shortcutItem = connectionOptions.shortcutItem, 
        let url = URL(string: shortcutItem.type) {
      scene.open(url, options: .none)
    }
  }
}
#endif
