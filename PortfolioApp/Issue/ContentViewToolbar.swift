//
//  ContentViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 13/5/25.
//

import SwiftUI

struct ContentViewToolbar: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
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
    }
}

#Preview {
    ContentViewToolbar()
        .environmentObject(DataController.preview)
}
