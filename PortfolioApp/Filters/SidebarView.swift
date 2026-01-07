//
//  SidebarView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct SidebarView: View {
  @StateObject private var viewModel: ViewModel
  let smartFilters: [Filter] = [.all, .recent]

  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List(selection: $viewModel.dataController.selectedFilter) {
      Section("Smart Filters") {
        ForEach(smartFilters, content: SmartFilterRow.init)
      }

      Section("Tags") {
        ForEach(viewModel.tagFilters) { filter in
          UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
        }
        .onDelete(perform: viewModel.delete)
      }
    }
    .toolbar(content: SidebarViewToolbar.init)
    .alert("Rename tag", isPresented: $viewModel.renamingTag) {
      Button("OK", action: viewModel.completeRename)
      Button("Cancel", role: .cancel) { }
      TextField("New name", text: $viewModel.tagName)
    }
    .navigationTitle("Filters")
    .macFrame(minWidth: 220)
  }
}

#Preview {
  NavigationView {
    SidebarView(dataController: .preview)
  }
}
