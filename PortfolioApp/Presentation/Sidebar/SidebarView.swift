//
//  SidebarView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct SidebarView: View {
  @EnvironmentObject var filterState: FilterState
  @StateObject private var viewModel: SidebarViewVM

  init() {
    let viewModel = SidebarViewVM()
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List(selection: $filterState.selectedFilter) {
      smartFilterView
      tagFilterView
    }
    .toolbar(content: {
      SidebarViewToolbar(showingAward: $viewModel.showingAward)
    })
    .navigationTitle("Filters")
    .showAlert(item: $viewModel.appAlert)
    .background(Color.appTheme.viewBackground)
  }
}

extension SidebarView {
  var smartFilterView: some View {
    Section("Smart Filters") {
      ForEach(viewModel.smartFilter) { filter in
        SmartFilterRow(filter: filter)
      }
    }
  }

  var tagFilterView: some View {
    Section("Tags") {
      ForEach(viewModel.tagFilters) { filter in
        UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
      }.onDelete(perform: viewModel.delete(_:))
    }
  }
}

#Preview {
  NavigationView {
    SidebarView()
  }
}
