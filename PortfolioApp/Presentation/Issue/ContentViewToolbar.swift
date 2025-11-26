//
//  ContentViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 13/5/25.
//

import SwiftUI

struct ContentViewToolbar: View {

  @ObservedObject var persistenceService: PersistenceService

  init(persistenceService: PersistenceService = Inject().wrappedValue) {
    self.persistenceService = persistenceService
  }

  var body: some View {
    Button(
      persistenceService.filterEnabled ? "Turn Filter Off" : "Turn Filter On"
    ) {
      persistenceService.filterEnabled.toggle()
    }
    Menu("Sort By") {
      Picker("Sort By", selection: $persistenceService.sortType) {
        Text("Created date").tag(SortType.createdDate)
        Text("Updated date").tag(SortType.updatedDate)
      }

      Divider()

      Picker("Sort Order", selection: $persistenceService.sortNewestFirst) {
        Text("Newest to Oldest").tag(true)
        Text("Oldest to Newest").tag(false)
      }
    }

    Picker("Status", selection: $persistenceService.filterStatus) {
      Text("All").tag(Status.all)
      Text("Open").tag(Status.open)
      Text("Closed").tag(Status.closed)
    }
    .disabled(persistenceService.filterEnabled == false)

    Picker("Priority", selection: $persistenceService.filterPriority) {
      Text("All").tag(-1)
      Text("Low").tag(0)
      Text("Medium").tag(1)
      Text("High").tag(2)
    }
    .disabled(persistenceService.filterEnabled == false)
  }
}

#Preview {
  ContentViewToolbar(persistenceService: .mock)
}
