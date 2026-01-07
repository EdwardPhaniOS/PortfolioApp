//
//  SidebarViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI

struct SidebarViewToolbar: View {
  @EnvironmentObject var dataController: DataController
  @State private var showingAwards = false
  @State private var showingStore = false
  
  var body: some View {
    Button(action: tryNewTag) {
      Label("Add tag", systemImage: "plus")
        .help("Add tag")
    }
    .sheet(isPresented: $showingStore, content: StoreView.init)
    
    Button {
      showingAwards.toggle()
    } label: {
      Label("Show awards", systemImage: "rosette")
        .help("Show awards")
    }
    .sheet(isPresented: $showingAwards, content: AwardsView.init)
    
#if DEBUG
    Button {
      dataController.deleteAll()
      dataController.createSampleData()
    } label: {
      Label("ADD SAMPLES", systemImage: "flame")
        .help("ADD SAMPLES")
    }
#endif
  }
  
  func tryNewTag() {
    if dataController.newTag() == false {
      showingStore = true
    }
  }
}

struct SidebarViewToolbar_Previews: PreviewProvider {
  static var previews: some View {
    SidebarViewToolbar()
  }
}

#Preview {
  SidebarViewToolbar()
}
