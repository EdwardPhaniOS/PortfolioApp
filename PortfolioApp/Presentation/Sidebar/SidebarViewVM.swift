//
//  SidebarViewModel.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 31/5/25.
//

import Foundation
import CoreData
import Combine

@MainActor
class SidebarViewVM: NSObject, ObservableObject, ErrorDisplayable {
  let tagService: TagService
  let smartFilter: [Filter] = [.all, .recent]

  @Published var showingAward = false
  @Published var appAlert: AppAlert?
  @Published var error: Error?
  var cancellable: Set<AnyCancellable> = Set()

  @Published var tagFilters: [Filter] = []

  init(tagService: TagService = Inject().wrappedValue) {
    self.tagService = tagService
    super.init()
    setSubscribers()
  }

  func setSubscribers() {
    tagService.tagsPublisher.sink { [weak self] completion in
      guard let self = self else { return }
      if case let .failure(err) = completion {
        error = DefaultAppError(title: "Error", message: err.localizedDescription)
      }
    } receiveValue: { [weak self] tags in
      guard let self = self else { return }
      self.tagFilters = tags.map { tag in
        Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
      }
    }
    .store(in: &cancellable)
  }

  func delete(_ offsets: IndexSet) {
    for offset in offsets {
      guard let tag = tagFilters[offset].tag else { return }
      tagService.delete(tag: tag)
    }
  }

  func rename(_ filter: Filter) {
    let textFieldConfig = AppAlert.TextFieldConfig(text: filter.name) { [weak self] newName in
      guard let self = self else { return }
      guard let tag = filter.tag else { return }

      tagService.rename(tag: tag, newName: newName)
    }
    appAlert = AppAlert(title: "Rename", message: "", textFieldConfig: textFieldConfig)
  }

  func delete(_ filter: Filter) {
    guard let tag = filter.tag else { return }
    tagService.delete(tag: tag)
  }
}
