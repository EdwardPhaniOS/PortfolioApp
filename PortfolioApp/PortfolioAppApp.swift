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
  @StateObject var filterState: FilterState = FilterState()

  var diContainer: DIContainer = {
    let container = DIContainer.shared
    container.load(modules: [
      ServiceModule()
    ])
    return container
  }()

  init() {
    let baseService: BaseService = Inject().wrappedValue
    baseService.setupSpotlightIndexing()

#if DEBUG
    if CommandLine.arguments.contains("enable-testing") {
      let issueService: IssueService = Inject().wrappedValue
      let tagService: TagService = Inject().wrappedValue

      issueService.deleteAll()
      tagService.deleteAll()
      UIView.setAnimationsEnabled(false)
    }
#endif
  }

  var body: some Scene {
    WindowGroup {
      NavigationSplitView {
        SidebarView()
      } content: {
        ContentView()
      } detail: {
        DetailView()
      }
      .environmentObject(filterState)
      .onChange(of: scenePhase) { _, newValue in
        if newValue != .active {
          let baseService: BaseService = Inject().wrappedValue
          baseService.save()
        }
      }
      .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
    }
  }

  func loadSpotlightItem(_ userActivity: NSUserActivity) {
    if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
      let issueService = diContainer.resolve(type: IssueService.self)
      filterState.selectedIssue = issueService.issue(with: uniqueIdentifier)
      filterState.selectedFilter = .all
    }
  }
}
