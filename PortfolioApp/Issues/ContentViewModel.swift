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
    var dataController: DataController
    
    init(dataController: DataController) {
      self.dataController = dataController
      
      NotificationCenter.default
        .addObserver(forName: .addNewIssue, object: nil, queue: .main) { [weak self] _ in
          self?.newIssue()
        }
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
      dataController[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
      get { dataController[keyPath: keyPath] }
      set { dataController[keyPath: keyPath] = newValue }
    }
    
    func delete(_ offsets: IndexSet) {
      let issues = dataController.issuesForSelectedFilter()
      
      for offset in offsets {
        let item = issues[offset]
        dataController.delete(item)
      }
    }
    
    func newIssue() {
      dataController.newIssue()
    }
    
    func openURL(_ url: URL) {
      if url.absoluteString.contains("newIssue") {
        newIssue()
      } else if let issue = dataController.issue(with: url.absoluteString) {
        dataController.selectedIssue = issue
        dataController.selectedFilter = .all
      }
    }
  }
}
