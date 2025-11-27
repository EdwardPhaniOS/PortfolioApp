//
//  AwardView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import SwiftUI

struct AwardView: View {
  var awardService: AwardService

  @Environment(\.dismiss) private var dismiss
  @State private var selectedAward = Award.example
  @State private var appAlert: AppAlert?

  init(awardService: AwardService = Inject().wrappedValue) {
    self.awardService = awardService
  }

  var columns: [GridItem] {
    [GridItem(.adaptive(minimum: 100, maximum: 100))]
  }

  var awardTitle: String {
    awardService.hasEarned(
      award: selectedAward) ? "Unlocked \(selectedAward.name)" : "Locked"
  }

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(Award.allAwards) { award in
          Image(systemName: award.image)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(width: 100, height: 100)
            .foregroundStyle(color(for: award))
            .plainButton()
            .button {
              selectedAward = award
              appAlert = AppAlert(title: awardTitle, message: selectedAward.description)
            }
            .accessibilityLabel(label(for: award))
            .accessibilityHint(award.description)
        }
      }
    }
    .navigationTitle("Awards")
    .showAlert(item: $appAlert)
    .toolbar { toolbarContent }
  }

  func color(for award: Award) -> Color {
    awardService.hasEarned(award: award) ? Color.appTheme.success : Color.appTheme.neutralAction
  }

  func label(for award: Award) -> LocalizedStringKey {
    awardService.hasEarned(award: award) ? "Unlocked \(award.name)" : "Locked"
  }
}

extension AwardView {

  @ToolbarContentBuilder
  var toolbarContent: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Image(systemName: "xmark")
        .plainButton(tintColor: Color.appTheme.accent)
        .button(.press) {
          dismiss()
        }
    }
  }
}

#Preview {
  NavigationView {
    AwardView(awardService: .mock)
  }
}
