//
//  IssueViewToolbar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 3/5/25.
//

import SwiftUI
import CoreHaptics

struct IssueViewToolbar: View {
    @EnvironmentObject var dataController: PersistenceService
    @ObservedObject var issue: Issue

    @State private var engine = try? CHHapticEngine()

    var openCloseButtonText: String {
        issue.completed ? "Re-open Issue" : "Close Issue"
    }

    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = issue.issueTitle
            } label: {
                Label("Copy Issue Title", systemImage: "doc.on.doc")
            }

            Button {
                toggleCompleted()
            } label: {
                Label(openCloseButtonText, systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
//            .sensoryFeedback(trigger: issue.completed) { oldValue, newValue in
//                return newValue ? .success : .none
//            }

            Divider()

            Section("Tags") {
                TagsMenuView(issue: issue)
            }
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }

    }

    func toggleCompleted() {
        issue.completed.toggle()
        dataController.save()

        if issue.completed {
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(
                    parameterID: .hapticSharpness,
                    value: 0
                )

                let intensity = CHHapticEventParameter(
                    parameterID: .hapticIntensity,
                    value: 1
                )

                let start = CHHapticParameterCurve.ControlPoint(
                    relativeTime: 0,
                    value: 1
                )

                let end = CHHapticParameterCurve.ControlPoint(
                    relativeTime: 1,
                    value: 0
                )

                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125, duration: 1,
                )

                let hapticPattern = try CHHapticPattern(
                    events: [event1, event2],
                    parameterCurves: [parameter]
                )
                let player = try engine?.makePlayer(with: hapticPattern)
                try player?.start(atTime: 0)
            } catch {
                print("Playing haptic feedback failed: \(error)")
            }
        }
    }
}

#Preview {
    IssueViewToolbar(issue: Issue.example)
}
