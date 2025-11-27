//
//  NoIssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct NoIssueView: View {
  @EnvironmentObject var filterState: FilterState
  @State var showDetailView: Bool = false
  var issueService: IssueService

  init(issueService: IssueService = Inject().wrappedValue) {
    self.issueService = issueService
  }

  var body: some View {
    Group {
      Text("No Issue".capitalized)
        .font(.title)
        .foregroundStyle(.secondary)

      Text("Add New Issue")
        .primaryButton()
        .button(.press) {
          issueService.newIssue(filterState: filterState)
        }
    }
    .padding()
    .navigationDestination(isPresented: $showDetailView) {
      DetailView()
    }
  }
}

#Preview {
  NoIssueView(issueService: .mock)
}
