//
//  TagService.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 27/11/25.
//

import Foundation
import Combine
import CoreData

class TagService: BaseService {
  let tagsPublisher = CurrentValueSubject<[Tag], Error>([])
  private let tagsController: NSFetchedResultsController<Tag>

  init(coreDataStack: CoreDataStack = Inject().wrappedValue) {
    let request = Tag.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]

    tagsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: coreDataStack.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    super.init(coreDataStack: coreDataStack)

    tagsController.delegate = self

    do {
      try tagsController.performFetch()
      let tags = tagsController.fetchedObjects ?? []
      tagsPublisher.send(tags)
    } catch {
      print("Failed to perform fetch")
      tagsPublisher.send(completion: .failure(error))
    }
  }

  func missingTags(from issue: Issue) -> [Tag] {
    let request = Tag.fetchRequest()
    let allTags = (try? coreDataStack.viewContext.fetch(request)) ?? []

    let allTagsSet = Set(allTags)
    let difference = allTagsSet.symmetricDifference(issue.issueTags)

    return difference.sorted()
  }

  func delete(tag: Tag) {
    delete(tag)
  }

  func deleteAll() {
    let request: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
    delete(request)
    save()
  }

  func rename(tag: Tag, newName: String) {
    tag.name = newName
    save()
  }

  func newTag() {
    let tag = Tag(context: coreDataStack.viewContext)
    tag.id = UUID()
    tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
    save()
  }
}

// MARK: NSFetchedResultsControllerDelegate
extension TagService: NSFetchedResultsControllerDelegate {
  nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    if let newTags = controller.fetchedObjects as? [Tag] {
      Task { @MainActor in
        tagsPublisher.send(newTags)
      }
    }
  }
}

extension TagService {
  static let mock: TagService = TagService(coreDataStack: .mock)
}
