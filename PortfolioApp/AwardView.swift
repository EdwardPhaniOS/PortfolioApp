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
    
    var awardTitle: LocalizedStringKey {
        dataController.hasEarned(award: selectedAward) ? LocalizedStringKey("Unlocked \(selectedAward.name)") : LocalizedStringKey("Locked")
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
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
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
    
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }
    
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked \(award.name)" : "Locked"
    }
}

#Preview {
    NavigationView(content: AwardView.init)
        .environmentObject(DataController.preview)
}
