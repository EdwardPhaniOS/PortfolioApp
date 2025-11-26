//
//  SidebarViewModel.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 31/5/25.
//

import Foundation
import CoreData

extension SidebarView {
  class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    var persistenceService: PersistenceService
    let smartFilter: [Filter] = [.all, .recent]

    @Published var tagToRename: Tag?
    @Published var tagName = ""
    @Published var renamingTag = false

    @Published var showingAward = false

    private let tagsController: NSFetchedResultsController<Tag>
    @Published var tags: [Tag] = []

    var tagFilters: [Filter] {
      tags.map { tag in
        Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
      }
    }

    init(persistenceService: PersistenceService = Inject().wrappedValue) {
      self.persistenceService = persistenceService

      let request = Tag.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]

      tagsController = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: persistenceService.coreDataStack.viewContext,
        sectionNameKeyPath: nil,
        cacheName: nil
      )

      super.init()
      tagsController.delegate = self

      do {
        try tagsController.performFetch()
        tags = tagsController.fetchedObjects ?? []
      } catch {
        print("Failed to perform fetch")
      }
    }

    func controllerDidChangeContent(
      _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
      if let newTags = controller.fetchedObjects as? [Tag] {
        self.tags = newTags
      }
    }

    func delete(_ offsets: IndexSet) {
      for offset in offsets {
        let item = tags[offset]
        persistenceService.delete(item)
      }
    }

    func rename(_ filter: Filter) {
      tagToRename = filter.tag
      tagName = filter.name
      renamingTag = true
    }

    func delete(_ filter: Filter) {
      guard let tag = filter.tag else { return }
      persistenceService.delete(tag)
      persistenceService.save()
    }

    func completeRename() {
      tagToRename?.name = tagName
      persistenceService.save()
    }
  }
}
