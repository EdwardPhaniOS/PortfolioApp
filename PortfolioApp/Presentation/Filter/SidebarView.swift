//
//  SidebarView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct SidebarView: View {
  @StateObject private var viewModel: ViewModel

  init() {
    let viewModel = ViewModel()
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List(selection: $viewModel.persistenceService.selectedFilter) {
      Section("Smart Filters") {
        ForEach(viewModel.smartFilter) { filter in
          SmartFilterRow(filter: filter)
        }
      }

      Section("Tags") {
        ForEach(viewModel.tagFilters) { filter in
          UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
        }.onDelete(perform: viewModel.delete(_:))
      }
    }
    .toolbar(content: {
      SidebarViewToolbar(showingAward: $viewModel.showingAward)
    })
    .navigationTitle("Filters")
    .alert("Rename tag", isPresented: $viewModel.renamingTag) {
      TextField("New name", text: $viewModel.tagName)
      Button("Cancel", role: .cancel) { }
      Button("OK", action: viewModel.completeRename)
    }

  }
}

#Preview {
  NavigationView {
    SidebarView()
  }
}
