//
//  AwardView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import SwiftUI

struct AwardsView: View {
  @EnvironmentObject var dataController: DataController

  @State private var selectedAward = Award.example
  @State private var appAlert: AppAlert?

  var columns: [GridItem] {
    [GridItem(.adaptive(minimum: 100, maximum: 100))]
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(Award.allAwards) { award in
            Button {
              selectedAward = award
              appAlert = AppAlert(title: awardTitle, message: selectedAward.description)
            } label: {
              Image(systemName: award.image)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 100, height: 100)
                .foregroundStyle(color(for: award))
            }
            .accessibilityLabel(label(for: award))
            .accessibilityHint(award.description)
          }
        }
      }
      .navigationTitle("Awards")
    }
    .showAlert(item: $appAlert)
  }

  var awardTitle: String {
    if dataController.hasEarned(award: selectedAward) {
      return "Unlocked: \(selectedAward.name)"
    } else {
      return "Locked"
    }
  }

  func color(for award: Award) -> Color {
    dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
  }

  func label(for award: Award) -> LocalizedStringKey {
    dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
  }
}

#Preview {
  NavigationView {
    AwardsView()
  }
}
