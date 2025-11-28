//
//  FilterState.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 27/11/25.
//

import Foundation

class FilterState: ObservableObject {
  @Published var selectedFilter: Filter? = Filter.all
  @Published var selectedIssue: Issue?

  @Published var filterText = ""
  @Published var filterTokens = [Tag]()

  @Published var filterEnabled = false
  @Published var filterPriority = -1
  @Published var filterStatus = Status.all
  @Published var sortType = SortType.createdDate
  @Published var sortNewestFirst = true
}
