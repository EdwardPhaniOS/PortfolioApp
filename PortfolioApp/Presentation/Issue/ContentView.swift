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

  init() {
    let viewModel = ViewModel()
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List(
      selection: $viewModel.selectedIssue,
      content: {
        ForEach(
          viewModel.persistenceService.issuesForSelectedFilter()
        ) { issue in
          IssueRow(issue: issue)
        }
        .onDelete(perform: viewModel.delete)
      })
    .navigationTitle("Issues")
    .toolbar {
      Menu {
        ContentViewToolbar()
      } label: {
        Label(
          "Filter",
          systemImage: "line.3.horizontal.decrease.circle"
        )
        .symbolVariant(viewModel.filterSymbolVariant)
      }

      Button {
        viewModel.addNewIssue()
      } label: {
        Label("New Issue", systemImage: "square.and.pencil")
          .accessibilityIdentifier("New Issue")
      }
    }
    .navigationDestination(isPresented: $viewModel.showDetailView) {
      DetailView()
    }
    //TODO: add search bar
//    .searchable(
//      text: $viewModel.filterText,
//      tokens: $viewModel.filterTokens,
//      suggestedTokens: .constant(viewModel.suggestedFilterTokens),
//      prompt: "Filter issue, or type # to add tags") { tag in
//        Text(tag.tagName)
//      }

  }
}

#Preview {
  NavigationView {
    ContentView()
  }
}
