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

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List(
selection: $viewModel.selectedIssue,
content: {
    ForEach(
        viewModel.dataController.issuesForSelectedFilter()
    ) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)
        })
        .navigationTitle("Issues")
        .searchable(
            text: $viewModel.filterText,
            tokens: $viewModel.filterTokens,
            suggestedTokens: .constant(viewModel.suggestedFilterTokens),
            prompt: "Filter issue, or type # to add tags") { tag in
                Text(tag.tagName)
            }
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

                Button(action: viewModel.dataController.newIssue, label: {
                    Label("New Issue", systemImage: "square.and.pencil")
                        .accessibilityIdentifier("New Issue")
                })
            }
    }
}

#Preview {
    NavigationView {
        ContentView(dataController: DataController.preview)
            .environmentObject(DataController.preview)
    }
}
