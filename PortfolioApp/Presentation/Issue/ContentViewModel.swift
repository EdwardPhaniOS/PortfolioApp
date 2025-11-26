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
    @Published var persistenceService: PersistenceService
    @Published var showDetailView: Bool = false

    var filterSymbolVariant: SymbolVariants {
      persistenceService.filterEnabled ? .fill : .none
    }

    init(persistenceService: PersistenceService = Inject().wrappedValue) {
      self.persistenceService = persistenceService
    }

    func addNewIssue() {
      persistenceService.newIssue()
      showDetailView = true
    }

    func delete(_ offsets: IndexSet) {
      let issues = persistenceService.issuesForSelectedFilter()

      for offset in offsets {
        let item = issues[offset]
        persistenceService.delete(item)
      }
    }

    subscript<Value>(dynamicMember keyPath: KeyPath<PersistenceService, Value>) -> Value {
      persistenceService[keyPath: keyPath]
    }

    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<PersistenceService, Value>) -> Value {
      get { persistenceService[keyPath: keyPath] }
      set { persistenceService[keyPath: keyPath] = newValue}
    }
  }
}
