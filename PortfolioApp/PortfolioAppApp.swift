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

  @Environment(\.scenePhase) var scenePhase

  var diContainer: DIContainer = {
    let container = DIContainer.shared

    container.register(type: CoreDataStack.self, lifeTime: .singleton) { _ in
      CoreDataStack()
    }

    container.register(type: PersistenceService.self, lifeTime: .singleton) { resolver in
      let coreDataStack = resolver.resolve(type: CoreDataStack.self)
      return PersistenceService(coreDataStack: coreDataStack)
    }

    return container
  }()

  var body: some Scene {
    WindowGroup {
      NavigationSplitView {
        SidebarView()
      } content: {
        ContentView()
      } detail: {
        DetailView()
      }
      .onChange(of: scenePhase) { _, newValue in
        if newValue != .active {
          let persistenceService: PersistenceService = Inject().wrappedValue
          persistenceService.save()
        }
      }
      .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
    }
  }

  func loadSpotlightItem(_ userActivity: NSUserActivity) {
    if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
      let persistenceService = diContainer.resolve(type: PersistenceService.self)
      persistenceService.selectedIssue = persistenceService.issue(with: uniqueIdentifier)
      persistenceService.selectedFilter = .all
    }
  }
}
