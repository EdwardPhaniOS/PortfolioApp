//
//  FilterService.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 27/11/25.
//

import Foundation
import Combine
import CoreData

class IssueService: BaseService {

  init(coreDataStack: CoreDataStack = Inject().wrappedValue) {
    super.init(coreDataStack: coreDataStack)
  }

  func issuesForSelectedFilter(filterState: FilterState) -> [Issue] {
    let filter = filterState.selectedFilter ?? .all
    var predicates = [NSPredicate]()

    if let tag = filter.tag {
      let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
      predicates.append(tagPredicate)
    } else {
      let datePredicate = NSPredicate(
        format: "modificationDate > %@",
        filter.minUpdatedDate as NSDate
      )
      predicates.append(datePredicate)
    }

    let trimmedFilterText = filterState.filterText.trimmingCharacters(in: .whitespaces)

    if trimmedFilterText.isEmpty == false {
      let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
      let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)

      let combinedPredicate = NSCompoundPredicate(
        orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
      )

      predicates.append(combinedPredicate)
    }

    if filterState.filterTokens.isEmpty == false {
      for filterToken in filterState.filterTokens {
        let tokenPredicate = NSPredicate(format: "tags CONTAINS %@", filterToken)
        predicates.append(tokenPredicate)
      }
    }

    if filterState.filterEnabled {
      if filterState.filterPriority >= 0 {
        let priorityFilter = NSPredicate(format: "priority = %d", filterState.filterPriority)
        predicates.append(priorityFilter)
      }

      if filterState.filterStatus != .all {
        let lookForClosed = filterState.filterStatus == .closed
        let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
        predicates.append(statusFilter)
      }
    }

    let request = Issue.fetchRequest()
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    request.sortDescriptors = [NSSortDescriptor(key: filterState.sortType.rawValue, ascending: filterState.sortNewestFirst)]
    let allIssues = (try? coreDataStack.viewContext.fetch(request)) ?? []
    return allIssues
  }

  func newIssue(filterState: FilterState? = nil) {
    let issue = Issue(context: coreDataStack.viewContext)
    issue.title = NSLocalizedString("New issue", comment: "Create a new issue")
    issue.creationDate = .now
    issue.priority = 1

    // If we are currently browsing a user-created tag, immediately
    // add this new issue to the tag otherwise it won't appear in
    // the list of issues they see.
    if let tag = filterState?.selectedFilter?.tag {
      issue.addToTags(tag)
    }

    save()

    filterState?.selectedIssue = issue
  }

  func issue(with uniqueIdentifier: String) -> Issue? {
    guard let url = URL(string: uniqueIdentifier) else {
      return nil
    }
    guard let id = coreDataStack.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
      return nil
    }

    return try? coreDataStack.viewContext.existingObject(with: id) as? Issue
  }

  func deleteAll() {
    let request: NSFetchRequest<NSFetchRequestResult> = Issue.fetchRequest()
    delete(request)
    save()
  }

}

extension IssueService {
  static let mock: IssueService = IssueService(coreDataStack: .mock)
}
