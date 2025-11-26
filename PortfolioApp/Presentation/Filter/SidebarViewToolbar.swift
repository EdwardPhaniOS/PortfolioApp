//
//  SidebarViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI

struct SidebarViewToolbar: View {
  var persistenceService: PersistenceService
  @Binding var showingAward: Bool

  init(persistenceService: PersistenceService = Inject().wrappedValue, showingAward: Binding<Bool>) {
    self.persistenceService = persistenceService
    _showingAward = showingAward
  }

  var body: some View {
#if DEBUG
    Button {
      persistenceService.deleteAll()
      persistenceService.createSampleData()
    } label: {
      Label("Add Sample", systemImage: "flame")
    }
#endif
    Button(action: persistenceService.newTag) {
      Label("Add Tag", systemImage: "plus")
    }

    Button {
      showingAward.toggle()
    } label: {
      Label("Show awards", systemImage: "rosette")
    }
    .sheet(isPresented: $showingAward, content: {
      AwardView()
    })
  }
}

#Preview {
  SidebarViewToolbar(showingAward: .constant(true))
}
