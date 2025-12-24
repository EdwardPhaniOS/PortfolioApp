//
//  PortfolioAppApp.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreSpotlight

@main
struct PortfolioAppApp: App {

  @StateObject var dataController = DataController()
  @Environment(\.scenePhase) var scenePhase

  var body: some Scene {
      WindowGroup {
          NavigationSplitView {
              SidebarView(dataController: dataController)
          } content: {
              ContentView(dataController: dataController)
          } detail: {
              DetailView()
          }
          .environment(\.managedObjectContext, dataController.container.viewContext)
          .environmentObject(dataController)
          .onChange(of: scenePhase) { phase in
              if phase != .active {
                  dataController.save()
              }
          }
          .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
      }
  }

  func loadSpotlightItem(_ userActivity: NSUserActivity) {
      if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
          dataController.selectedIssue = dataController.issue(with: uniqueIdentifier)
          dataController.selectedFilter = .all
      }
  }
}
