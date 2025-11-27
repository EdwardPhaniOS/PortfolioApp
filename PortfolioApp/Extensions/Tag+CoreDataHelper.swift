//
//  Tag-CoreDataHelper.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 16/3/25.
//

import Foundation
import CoreData

extension Tag {
  var tagID: UUID {
    id ?? UUID()
  }

  var tagName: String {
    name ?? ""
  }

  var tagActiveIssues: [Issue] {
    let result = issues?.allObjects as? [Issue] ?? []
    return result.filter { $0.completed == false }
  }

  static var example: Tag {
    let tagService = TagService.mock
    let viewContext = tagService.coreDataStack.viewContext

    let tag = Tag(context: viewContext)
    tag.name = "Example Tag"
    return tag
  }
}

extension Tag: Comparable {
  public static func < (lhs: Tag, rhs: Tag) -> Bool {
    let left = lhs.tagName.localizedLowercase
    let right = rhs.tagName.localizedLowercase

    if left == right {
      return lhs.tagID.uuidString < rhs.tagID.uuidString
    } else {
      return left < right
    }
  }
}
