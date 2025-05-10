//
//  ContentView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 14/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    var filterSymbolVariant: SymbolVariants {
        dataController.filterEnable ? .fill : .none
    }

    var body: some View {
        List(selection: $dataController.selectedIssue, content: {
            ForEach(dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
        })
        .navigationTitle("Issues")
        .searchable(
            text: $dataController.filterText,
            tokens: $dataController.filterTokens,
            suggestedTokens: .constant(dataController.suggestedFilterTokens),
            prompt: "Filter issue, or type # to add tags") { tag in
                Text(tag.tagName)
            }
            .toolbar {
                Menu {
                    Button(dataController.filterEnable ? "Turn Filter Off" : "Turn Filter On") {
                        dataController.filterEnable.toggle()
                    }
                    Menu("Sort By") {
                        Picker("Sort By", selection: $dataController.sortType) {
                            Text("Created date").tag(SortType.createdDate)
                            Text("Updated date").tag(SortType.updatedDate)
                        }

                        Divider()

                        Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                            Text("Newest to Oldest").tag(true)
                            Text("Oldest to Newest").tag(false)
                        }

                    }

                    Picker("Status", selection: $dataController.filterStatus) {
                        Text("All").tag(Status.all)
                        Text("Open").tag(Status.open)
                        Text("Closed").tag(Status.closed)
                    }
                    .disabled(dataController.filterEnable == false)

                    Picker("Priority", selection: $dataController.filterPriority) {
                        Text("All").tag(-1)
                        Text("Low").tag(0)
                        Text("Medium").tag(1)
                        Text("High").tag(2)
                    }
                    .disabled(dataController.filterEnable == false)

                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle").symbolVariant(filterSymbolVariant)
                }

                Button(action: dataController.newIssue) {
                    Label("New Issue", systemImage: "square.and.pencil")
                }

            }
    }

    func delete(_ offsets: IndexSet) {
        let issues = dataController.issuesForSelectedFilter()

        for offset in offsets {
            let item = issues[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
            .environmentObject(DataController.preview)
    }
}
