//
//  ContentViewModel.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 31/5/25.
//

import SwiftUI
import CoreData

extension ContentView {

    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        @Published var dataController: DataController

        var filterSymbolVariant: SymbolVariants {
            dataController.filterEnabled ? .fill : .none
        }

        init(dataController: DataController) {
            self.dataController = dataController
        }

        func delete(_ offsets: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()

            for offset in offsets {
                let item = issues[offset]
                dataController.delete(item)
            }
        }

        subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
            dataController[keyPath: keyPath]
        }

        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
            get { dataController[keyPath: keyPath] }
            set { dataController[keyPath: keyPath] = newValue}
        }
    }
}
