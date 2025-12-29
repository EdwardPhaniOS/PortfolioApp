//
//  NewIssueIntent.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 29/12/25.
//

import SwiftUI
import AppIntents

extension Notification.Name {
  static let addNewIssue = Notification.Name("addNewIssue")
}

struct NewIssueIntent: AppIntent {
  static var title: LocalizedStringResource = "New Issue"
  static var openAppWhenRun: Bool = true
  
  func perform() async throws -> some IntentResult {
    NotificationCenter.default.post(name: .addNewIssue, object: nil)
    return .result()
  }
}
