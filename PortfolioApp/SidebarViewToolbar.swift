//
//  SidebarViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @Binding var showingAward: Bool
    
    var body: some View {
    #if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("Add Sample", systemImage: "flame")
        }
    #endif
        
        Button(action: dataController.newTag) {
            Label("Add Tag", systemImage: "plus")
        }
        
        Button {
            showingAward.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
        .sheet(isPresented: $showingAward, content: AwardView.init)
    }
    
}

#Preview {
    SidebarViewToolbar(showingAward: .constant(true))
}
