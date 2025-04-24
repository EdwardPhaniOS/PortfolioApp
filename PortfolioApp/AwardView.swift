//
//  AwardView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import SwiftUI

struct AwardView: View {
    
    @EnvironmentObject var dataController: DataController
    
    @State private var selectedAward = Award.example
    @State private var showAwardDetails = false
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var awardTitle: String {
        dataController.hasEarned(award: selectedAward) ? "Unlocked \(selectedAward.name)" : "Locked"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5))
                        }
                        .accessibilityLabel(
                            dataController.hasEarned(award: award) ? "Unlocked \(award.name)" : "Locked"
                        )
                        .accessibilityHint(award.description)
                    }
                }
            }
        }
        .navigationTitle("Awards")
        .alert(awardTitle, isPresented: $showAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }

    }
}

#Preview {
    NavigationView(content: AwardView.init)
        .environmentObject(DataController.preview)
}
