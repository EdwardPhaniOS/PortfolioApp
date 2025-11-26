//
//  Filter.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import Foundation

struct Filter: Identifiable, Hashable {
  var id: UUID
  var name: String
  var icon: String
  var minUpdatedDate: Date
  var tag: Tag?

  init(id: UUID, name: String, icon: String, minUpdatedDate: Date = Date.distantPast, tag: Tag? = nil) {
    self.id = id
    self.name = name
    self.icon = icon
    self.minUpdatedDate = minUpdatedDate
    self.tag = tag
  }

  var activeIssuesCount: Int {
    tag?.tagActiveIssues.count ?? 0
  }

  static var all = Filter(
    id: UUID(),
    name: "All Issues",
    icon: "tray")
  static var recent = Filter(
    id: UUID(),
    name: "Recent Issues",
    icon: "clock",
    minUpdatedDate: .now.addingTimeInterval(86400 * -7))

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Filter, rhs: Filter) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
}
