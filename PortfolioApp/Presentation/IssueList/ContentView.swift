//
//  ContentView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @EnvironmentObject var filterState: FilterState
  @StateObject var viewModel: ContentViewVM

  init() {
    let viewModel = ContentViewVM()
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      searchBarView
      issueListView
    }
    .infinityFrame()
    .navigationTitle("Issues")
    .toolbar { toolbarContentView }
    .navigationDestination(isPresented: $viewModel.showDetailView) {
      DetailView()
    }
    .background(Color.appTheme.viewBackground)
  }

}

private extension ContentView {

  var searchBarView: some View {
    TextField("Search".capitalized, text: $filterState.filterText)
      .textField(
        sfSymbol: "magnifyingglass",
        resetAction: filterState.filterText.isEmpty ? nil : { filterState.filterText = "" }
      )
      .padding(.horizontal)
  }

  @ViewBuilder
  var issueListView: some View {
    List(
      selection: $filterState.selectedIssue,
      content: {
        ForEach(viewModel.issuesForSelectedFilter(filterState: filterState)) { issue in
          IssueRow(issue: issue)
        }
        .onDelete { indexSet in
          viewModel.delete(indexSet, filterState: filterState)
        }
      })
    .listStyle(.inset)
  }

  @ViewBuilder
  var toolbarContentView: some View {
    Menu {
      FilterMenuContentView()
    } label: {
      Label(
        "Filter",
        systemImage: "line.3.horizontal.decrease.circle"
      )
      .symbolVariant(filterSymbolVariant)
    }

    Button {
      viewModel.addNewIssue(filterState: filterState)
    } label: {
      Label("New Issue", systemImage: "square.and.pencil")
        .accessibilityIdentifier("New Issue")
    }
  }

  var filterSymbolVariant: SymbolVariants {
    filterState.filterEnabled ? .fill : .none
  }
}

private struct Preview: View {
  @StateObject var filterState: FilterState = FilterState()

  var body: some View {
    NavigationView {
      ContentView()
        .environmentObject(filterState)
    }
  }
}

#Preview {
  Preview()
}
