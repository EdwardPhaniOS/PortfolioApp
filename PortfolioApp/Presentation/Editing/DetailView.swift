//
//  DetailView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct DetailView: View {
  @ObservedObject var persistenceService: PersistenceService

  init(persistenceService: PersistenceService = Inject().wrappedValue) {
    self.persistenceService = persistenceService
  }

  var body: some View {
    VStack {
      if let issue = persistenceService.selectedIssue {
        IssueView(issue: issue)
      } else {
        NoIssueView()
      }
    }
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  DetailView(persistenceService: .mock)
}
