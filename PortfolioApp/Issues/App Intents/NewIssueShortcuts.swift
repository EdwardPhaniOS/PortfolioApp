//
//  NewIssueShortcuts.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 29/12/25.
//

import Foundation
import AppIntents

struct NewIssueShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] = [
    AppShortcut(
      intent: NewIssueIntent(),
      phrases: ["Create new issue in ${applicationName}",
                "Add issue with ${applicationName}",],
      shortTitle: "New Issue",
      systemImageName: "rectangle.stack.badge.plus"
    )
  ]
}
