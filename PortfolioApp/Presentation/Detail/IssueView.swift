//
//  IssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct IssueView: View {
  var baseService: BaseService
  @ObservedObject var issue: Issue
  @Environment(\.openURL) var openURL
  @State private var appAlert: AppAlert?

  init(issue: Issue, persistenceService: BaseService = Inject().wrappedValue) {
    self.issue = issue
    self.baseService = persistenceService
  }

  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          titleFieldView
          issueMetadataView
        }
        priorityPickerView
        TagsMenuView(issue: issue)
      }
      Section {
        basicInfoView
      }
      Section("Reminder") {
        reminderView
      }
    }
    .disabled(issue.isDeleted)
    .onReceive(issue.objectWillChange) { _ in
      baseService.queueSave()
    }
    .onSubmit(baseService.save)
    .toolbar {
      IssueViewToolbar(issue: issue)
    }
    .showAlert(item: $appAlert)
    .onChange(of: issue.reminderEnabled) { _, _ in
      updateReminder()
    }
    .onChange(of: issue.reminderTime) { _, _ in
      updateReminder()
    }
  }
}

extension IssueView {
  var titleFieldView: some View {
    TextField("Title", text: $issue.issueTitle, prompt: Text("Enter the issue title here"))
  }

  @ViewBuilder
  var issueMetadataView: some View {
    Text("**Modified:** \(issue.issueModificationDate.formatted(date: .long, time: .shortened))")
      .foregroundStyle(.secondary)

    Text("**Status:** \(issue.issueStatus)")
      .foregroundStyle(.secondary)
  }

  var priorityPickerView: some View {
    Picker("Priority", selection: $issue.priority) {
      Text("Low").tag(Int16(0))
      Text("Medium").tag(Int16(1))
      Text("High").tag(Int16(2))
    }
  }

  var basicInfoView: some View {
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

  @ViewBuilder
  var reminderView: some View {
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

extension IssueView {
  func showAppSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }

    openURL(settingsURL)
  }

  func updateReminder() {
    baseService.removeReminders(for: issue)

    Task { @MainActor in
      if issue.reminderEnabled {
        let success = await baseService.addReminder(for: issue)

        if !success {
          issue.reminderEnabled = false

          let action = AppAlert.ActionButton(title: "Settings", action: showAppSettings)

          appAlert = AppAlert(
            title: "Oops!",
            message: "Notifications are not enabled. Please check you have notifications enabled in your app settings.",
            actionButton: action)
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
