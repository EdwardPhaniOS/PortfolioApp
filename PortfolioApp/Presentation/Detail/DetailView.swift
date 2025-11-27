//
//  DetailView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct DetailView: View {
  @EnvironmentObject var filterState: FilterState

  var body: some View {
    VStack {
      if let issue = filterState.selectedIssue {
        IssueView(issue: issue)
      }
    }
    .infinityFrame()
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color.appTheme.viewBackground)
  }
}

private struct Preview: View {
  @StateObject var filterState = FilterState()

  var body: some View {
    DetailView()
      .environmentObject(filterState)
  }
}

#Preview {
  Preview()
}
