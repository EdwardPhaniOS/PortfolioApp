//
//  DataController.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import CoreData
import SwiftUI

enum SortType: String {
  case createdDate = "creationDate"
  case updatedDate = "modificationDate"
}

enum Status {
  case all, open, closed
}

class BaseService: NSObject, ObservableObject {
  let coreDataStack: CoreDataStack
  let defaults: UserDefaults

  private var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?

  private var saveTask: Task<Void, Error>?

  /// Initializes a data controller, either in memory (for testing use such as previewing),
  /// or on permanent storage (for use in regular app runs.)
  ///
  /// Defaults to permanent storage.
  /// - Parameter inMemory: Whether to store this data in temporary memory or not.
  init(coreDataStack: CoreDataStack, defaults: UserDefaults = .standard) {
    self.defaults = defaults
    self.coreDataStack = coreDataStack

    super.init()

    NotificationCenter.default.addObserver(
      forName: .NSPersistentStoreRemoteChange,
      object: coreDataStack.persistentStoreCoordinator,
      queue: .main,
      using: remoteStoreChanged
    )
  }

  func setupSpotlightIndexing() {
    if let description = coreDataStack.persistentStoreDescriptions.first {
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

      let coordinator = coreDataStack.persistentStoreCoordinator

      spotlightDelegate = NSCoreDataCoreSpotlightDelegate(
        forStoreWith: description,
        coordinator: coordinator
      )

      spotlightDelegate?.startSpotlightIndexing()
    }
  }

  func remoteStoreChanged(_ notification: Notification) {
    objectWillChange.send()
  }

  /// Saves our Core Data context iff there are changes. This silently ignores
  /// any errors caused by saving, but this should be fine because
  /// all our attributes are optional.
  func save() {
    saveTask?.cancel()
    coreDataStack.saveContext()
  }

  func queueSave() {
    saveTask?.cancel()

    saveTask = Task { @MainActor in
      try await Task.sleep(for: .seconds(3))
      save()
    }
  }

  func delete(_ object: NSManagedObject) {
    objectWillChange.send()
    coreDataStack.viewContext.delete(object)
    save()
  }

  func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    batchDeleteRequest.resultType = .resultTypeObjectIDs

    // ⚠️ When performing a batch delete we need to make sure we read the result back
    // then merge all the changes from that result back into our live view context
    // so that the two stay in sync.
    if let delete = try? coreDataStack.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
      let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [coreDataStack.viewContext])
    }
  }

  func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
    (try? coreDataStack.viewContext.count(for: fetchRequest)) ?? 0
  }
}

extension BaseService {

  func createSampleData() {
    let viewContext = coreDataStack.viewContext

    for tagCounter in 1...5 {
      let tag = Tag(context: viewContext)
      tag.id = UUID()
      tag.name = "Tag \(tagCounter)"

      for issueCounter in 1...10 {
        let issue = Issue(context: viewContext)
        issue.title = "Issue \(tagCounter)-\(issueCounter)"
        issue.content = "Description goes here"
        issue.creationDate = .now
        issue.completed = Bool.random()
        issue.priority = Int16.random(in: 0...2)
        tag.addToIssues(issue)
      }
    }

    try? viewContext.save()
  }
}
