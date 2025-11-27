//
//  CoreDataStack.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 26/11/25.
//

import Foundation
import CoreData

class CoreDataStack {

  private let container: NSPersistentCloudKitContainer

  static let model: NSManagedObjectModel = {
    guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
      fatalError("Failed to locate model file.")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to load model file.")
    }

    return managedObjectModel
  }()

  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

    // For testing and previewing purposes, we create a
    // temporary, in-memory database by writing to /dev/null
    // so our data is destroyed after the app finishes running.
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    // Make sure that we watch iCloud for all changes to make
    // absolutely sure we keep our local UI in sync when a
    // remote change happens.
    container.persistentStoreDescriptions.first?.setOption(
      true as NSNumber,
      forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
    )

    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
    }
  }

  var viewContext: NSManagedObjectContext {
    return container.viewContext
  }

  var newBackgroundContext: NSManagedObjectContext {
    let context = container.newBackgroundContext()
    context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    return context
  }

  var persistentStoreCoordinator: NSPersistentStoreCoordinator {
    container.persistentStoreCoordinator
  }

  var persistentStoreDescriptions: [NSPersistentStoreDescription] {
    container.persistentStoreDescriptions
  }

  func saveContext(context: NSManagedObjectContext? = nil) {
    let mContext = context ?? viewContext
    if mContext.hasChanges {
      do {
        try mContext.save()
      } catch {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
    }
  }

}

extension CoreDataStack {
  static let mock = CoreDataStack(inMemory: true)
}
