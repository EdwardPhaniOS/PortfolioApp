//
//  ContentViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 13/5/25.
//

import SwiftUI

struct FilterMenuContentView: View {
  @EnvironmentObject var filterState: FilterState

  var body: some View {
    Button(
      filterState.filterEnabled ? "Turn Filter Off" : "Turn Filter On"
    ) {
      filterState.filterEnabled.toggle()
    }
    Menu("Sort By") {
      Picker("Sort By", selection: $filterState.sortType) {
        Text("Created date").tag(SortType.createdDate)
        Text("Updated date").tag(SortType.updatedDate)
      }

      Divider()

      Picker("Sort Order", selection: $filterState.sortNewestFirst) {
        Text("Newest to Oldest").tag(true)
        Text("Oldest to Newest").tag(false)
      }
    }

    Picker("Status", selection: $filterState.filterStatus) {
      Text("All").tag(Status.all)
      Text("Open").tag(Status.open)
      Text("Closed").tag(Status.closed)
    }
    .disabled(filterState.filterEnabled == false)

    Picker("Priority", selection: $filterState.filterPriority) {
      Text("All").tag(-1)
      Text("Low").tag(0)
      Text("Medium").tag(1)
      Text("High").tag(2)
    }
    .disabled(filterState.filterEnabled == false)
  }
}

#Preview {
  FilterMenuContentView()
}
