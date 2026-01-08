//
//  IssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct IssueView: View {
  @EnvironmentObject var dataController: DataController
  @ObservedObject var issue: Issue

  @State private var showingNotificationsError = false
  @State private var appAlert: AppAlert?
  @Environment(\.openURL) var openURL

  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
            .font(.title)
            .labelsHidden()

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
        VStack(alignment: .leading) {
          Text("Basic Information")
            .font(.title2)
            .foregroundStyle(.secondary)

          TextField(
            "Description",
            text: $issue.issueContent,
            prompt: Text("Enter the issue description here"),
            axis: .vertical
          )
          .labelsHidden()
        }
      }

      Section("Reminders") {
        Toggle("Show reminders", isOn: $issue.reminderEnabled.animation())

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
#if os(visionOS) || os(macOS)
      dataController.save()
#else
      dataController.queueSave()
#endif
    }
    .onSubmit(dataController.save)
    .toolbar {
      IssueViewToolbar(issue: issue)
    }
    .showAlert(item: $appAlert)
    .onChange(of: issue.reminderEnabled, updateReminder)
    .onChange(of: issue.reminderTime, updateReminder)
    .formStyle(.grouped)
  }

  #if os(iOS)
  func showAppSettings() {
    guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
      return
    }

    openURL(settingsURL)
  }
#endif

  func updateReminder() {
    dataController.removeReminders(for: issue)

    Task { @MainActor in
      if issue.reminderEnabled {
        let success = await dataController.addReminder(for: issue)

        if success == false {
          issue.reminderEnabled = false
          showingNotificationsError = true
          
          var action: AppAlert.ActionButton?
#if os(iOS)
          action = AppAlert.ActionButton(title: "Check Settings", action: showAppSettings)
#endif
          appAlert = AppAlert(title: "Oops!", message: "There was a problem setting your notification. Please check you have notifications enabled.", actionButton: action)
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
