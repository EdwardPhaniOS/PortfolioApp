//
//  AwardView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import SwiftUI

struct AwardsView: View {
  @EnvironmentObject var dataController: DataController
  @Environment(\.dismiss) var dismiss
  
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
            .buttonStyle(.borderless)
            .accessibilityLabel(label(for: award))
            .accessibilityHint(award.description)
          }
        }
      }
      .navigationTitle("Awards")
    }
    .showAlert(item: $appAlert)
    .macFrame(minWidth: 600, maxHeight: 500)
#if !os(watchOS)
    .toolbar {
      Button("Close") {
        dismiss()
      }
    }
#endif
  }
  
  var awardTitle: String {
    if dataController.hasEarned(award: selectedAward) {
      return String(format: NSLocalizedString("Unlocked: %@", comment: ""), selectedAward.name)
    } else {
      return NSLocalizedString("Locked", comment: "")
    }
  }
  
  func color(for award: Award) -> Color {
    dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
  }
  
  func label(for award: Award) -> String {
    dataController.hasEarned(award: award)
    ? String(format: NSLocalizedString("Unlocked: %@", comment: ""), award.name)
    : NSLocalizedString("Locked", comment: "")
  }
}

#Preview {
  NavigationView {
    AwardsView()
  }
}
