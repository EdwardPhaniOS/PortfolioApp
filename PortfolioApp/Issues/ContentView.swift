//
//  ContentView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    List(selection: $viewModel.selectedIssue) {
      ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
        IssueRow(issue: issue)
      }
      .onDelete(perform: viewModel.delete)
    }
    .onOpenURL(perform: openURL)
    .navigationTitle("Issues")
    .searchable(
      text: $viewModel.filterText,
      tokens: $viewModel.filterTokens,
      suggestedTokens: .constant(viewModel.suggestedFilterTokens),
      prompt: "Filter issues"
    ) { tag in
      Text(tag.tagName)
    }
    .toolbar(content: ContentViewToolbar.init)
  }
  
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  func openURL(_ url: URL) {
    if url.absoluteString.contains("newIssue") {
      viewModel.newIssue()
    }
  }
}

#Preview {
  ContentView(dataController: .preview)
}
