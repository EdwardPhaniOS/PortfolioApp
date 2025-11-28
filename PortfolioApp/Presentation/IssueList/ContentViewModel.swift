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

  private var saveTask: Task<Void, Error>?

  init(issueService: IssueService = Inject().wrappedValue) {
    self.issueService = issueService
  }

  func addNewIssue(filterState: FilterState? = nil) {
    issueService.newIssue(filterState: filterState)
    showDetailView = true
  }

  func issuesForSelectedFilter(filterState: FilterState) -> [Issue] {
    return issueService.issuesForSelectedFilter(filterState: filterState)
  }

  func delete(_ offsets: IndexSet, filterState: FilterState) {
    let issues = issuesForSelectedFilter(filterState: filterState)
    
    for offset in offsets {
      let item = issues[offset]
      issueService.delete(item)
    }
  }
}
