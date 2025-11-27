//
//  SidebarViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI

struct SidebarViewToolbar: View {
  private let tagService: TagService
  @Binding var showingAward: Bool

  init(showingAward: Binding<Bool>, tagService: TagService = Inject().wrappedValue) {
    _showingAward = showingAward
    self.tagService = tagService
  }

  var body: some View {
#if DEBUG
    Button {
      createSampleData()
    } label: {
      Label("Add Sample", systemImage: "flame")
    }
#endif
    Button(action: tagService.newTag) {
      Label("Add Tag", systemImage: "plus")
    }

    Button {
      showingAward.toggle()
    } label: {
      Label("Show awards", systemImage: "rosette")
    }
    .sheet(isPresented: $showingAward, content: {
      NavigationStack {
        AwardView()
      }
    })
  }
}

extension SidebarViewToolbar {

  func createSampleData() {
    let coreDataStack: CoreDataStack = Inject().wrappedValue
    let tagService: TagService = Inject().wrappedValue
    let issueService: IssueService = Inject().wrappedValue
    let viewContext = coreDataStack.viewContext

    tagService.deleteAll()
    issueService.deleteAll()

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

#Preview {
  SidebarViewToolbar(showingAward: .constant(true))
}
