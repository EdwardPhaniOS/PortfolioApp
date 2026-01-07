//
//  ContentView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreData
import AppIntents

struct ContentView: View {
  @StateObject var viewModel: ViewModel

  var body: some View {
    List(selection: $viewModel.selectedIssue) {
      ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
#if os(watchOS)
        IssueRowWatch(issue: issue)
#else
        IssueRow(issue: issue)
#endif
      }
      .onDelete(perform: viewModel.delete)
    }
    .onOpenURL(perform: viewModel.openURL)
    .navigationTitle("Issues")
#if !os(watchOS)
    .searchable(
      text: $viewModel.filterText,
      tokens: $viewModel.filterTokens,
      prompt: "Filter issues"
    ) { tag in
      Text(tag.tagName)
    }
    .searchSuggestions {
      ForEach(viewModel.suggestedFilterTokens) { tag in
        Text(tag.tagName)
          .foregroundStyle(Color.appTheme.accent)
          .button { 
            viewModel.filterTokens.append(tag)
            viewModel.filterText = ""
          }
      }
    }
#endif
    .toolbar(content: ContentViewToolbar.init)
    .macFrame(minWidth: 220)
  }
  
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
}

#Preview {
  ContentView(dataController: .preview)
}
