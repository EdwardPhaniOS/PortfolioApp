//
//  TagMenuView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI

struct TagsMenuView: View {
  var persistenceService: PersistenceService
  @ObservedObject var issue: Issue

  init(persistenceService: PersistenceService = Inject().wrappedValue, issue: Issue) {
    self.persistenceService = persistenceService
    self.issue = issue
  }

  var body: some View {
    Menu {
      // Show selected tags first
      ForEach(issue.issueTags) { tag in
        Button {
          issue.removeFromTags(tag)
        } label: {
          Label(tag.tagName, systemImage: "checkmark")
        }
      }

      // Now show unselected tags
      let otherTags = persistenceService.missingTags(from: issue)

      if otherTags.isEmpty == false {
        Divider()

        Section("Add Tags") {
          ForEach(otherTags) { tag in
            Button(tag.tagName) {
              issue.addToTags(tag)
            }
          }
        }
      }
    } label: {
      Text(issue.issueTagsList)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(nil, value: issue.issueTagsList)
    }
  }
}

#Preview {
  TagsMenuView(persistenceService: .mock, issue: .example)
}
