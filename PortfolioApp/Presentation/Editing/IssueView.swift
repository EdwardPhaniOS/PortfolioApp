//
//  IssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct IssueView: View {
  var persistenceService: PersistenceService
  @ObservedObject var issue: Issue

  @State private var showingNotificationsError = false
  @Environment(\.openURL) var openURL

  init(issue: Issue, persistenceService: PersistenceService = Inject().wrappedValue) {
    self.issue = issue
    self.persistenceService = persistenceService
  }

  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))

          Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
            .foregroundStyle(.secondary)

          Text("**Status:** \(issue.issueStatus)")
            .foregroundStyle(.secondary)
        }

        Picker("Priority", selection: $issue.priority) {
          Text("Low").tag(Int16(0))
          Text("Medium").tag(Int16(1))
          Text("High").tag(Int16(2))
        }

        TagsMenuView(issue: issue)
      }

      Section {
        VStack {
          Text("Basic Information")
            .font(.title2)
            .foregroundStyle(.secondary)
          TextField("Description",
                    text: $issue.issueContent,
                    prompt: Text("Enter the issue description here"),
                    axis: .vertical)
        }
      }

      Section("Reminder") {
        Toggle(
          "Show reminders",
          isOn: $issue.reminderEnabled.animation()
        )

        if issue.reminderEnabled {
          DatePicker(
            "Reminder time",
            selection: $issue.issueReminderTime,
            displayedComponents: .hourAndMinute
          )
        }

      }
    }
    .disabled(issue.isDeleted)
    .onReceive(issue.objectWillChange) { _ in
      persistenceService.queueSave()
    }
    .onSubmit(persistenceService.save)
    .toolbar {
      IssueViewToolbar(issue: issue)
    }
    .alert("Oops!", isPresented: $showingNotificationsError) {
      Button("Check settings", action: showAppSettings)
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Notifications are not enabled. Please check you have notifications enabled in your app settings.")
    }
    .onChange(of: issue.reminderEnabled) { _, _ in
      updateReminder()
    }
    .onChange(of: issue.reminderTime) { _, _ in
      updateReminder()
    }
  }

  func showAppSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

    openURL(settingsURL)
  }

  func updateReminder() {
    persistenceService.removeReminders(for: issue)

    Task { @MainActor in
      if issue.reminderEnabled {
        let success = await persistenceService.addReminder(for: issue)

        if !success {
          issue.reminderEnabled = false
          showingNotificationsError = true
        }
      }
    }
  }
}

#Preview {
  NavigationView {
    IssueView(issue: .example)
  }
}
