//
//  ContentView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {

  @StateObject var viewModel: ContentViewVM
  @EnvironmentObject var filterState: FilterState

  init() {
    let viewModel = ContentViewVM()
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      searchBarView
      ZStack {
        issueListView
        NoIssueView()
          .opacity(viewModel.issues.isEmpty ? 1 : 0)
      }
    }
    .task {
      viewModel.fetchIssue(filterState: filterState)
    }
    .onChange(of: filterState.filterText, { _, _ in
      viewModel.fetchIssue(filterState: filterState)
    })
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
        ForEach(viewModel.issues) { issue in
          IssueRow(issue: issue)
        }
        .onDelete(perform: viewModel.delete)
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
      viewModel.addNewIssue()
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
