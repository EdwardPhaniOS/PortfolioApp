//
//  ContentViewModel.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 31/5/25.
//

import SwiftUI
import CoreData

@MainActor
class ContentViewVM: ObservableObject {
  @Published var issueService: IssueService
  @Published var showDetailView: Bool = false
  @Published var issues: [Issue] = []

  init(issueService: IssueService = Inject().wrappedValue) {
    self.issueService = issueService
  }

  func addNewIssue() {
    issueService.newIssue()
    showDetailView = true
  }

  func fetchIssue(filterState: FilterState) {
    self.issues = issueService.issuesForSelectedFilter(filterState: filterState)
  }

  func delete(_ offsets: IndexSet) {
    for offset in offsets {
      let item = issues[offset]
      issueService.delete(item)
    }
  }
}
