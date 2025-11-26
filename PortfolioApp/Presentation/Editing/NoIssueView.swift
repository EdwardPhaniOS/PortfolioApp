//
//  NoIssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct NoIssueView: View {
  var persistenceService: PersistenceService
  @State var showDetailView: Bool = false

  init(persistenceService: PersistenceService = Inject().wrappedValue) {
    self.persistenceService = persistenceService
  }

  var body: some View {
    Group {
      Text("No Issue Selected")
        .font(.title)
        .foregroundStyle(.secondary)

      Button("New Issue") {
        persistenceService.newIssue()
      }
    }
    .navigationDestination(isPresented: $showDetailView) {
      DetailView()
    }
  }
}

#Preview {
  NoIssueView(persistenceService: .mock)
}
