//
//  AlertView.swift
//  UberClone
//
//  Created by Vinh Phan on 13/11/25.
//

import SwiftUI

struct AlertView: View {
  enum Field {
    case nameField
  }

  @FocusState private var focusedField: Field?

  @Binding var alert: AppAlert?
  @State var inputText: String = ""

  var appAlert: AppAlert {
    return alert ?? .empty
  }

  var body: some View {
    VStack {
      headingView
      messageView
      textFieldView
      actionButtons
    }
    .padding(12)
    .background(Color.appTheme.cellBackground)
    .cornerRadius(.cell)
    .frame(width: UIScreen.main.bounds.width / 1.2)
    .task {
      inputText = appAlert.textFieldConfig?.text ?? .empty
      focusedField = .nameField
    }
  }
}

private extension AlertView {
  func dismiss() {
    alert = nil
  }
}

private extension AlertView {
  var headingView: some View {
    Text(LocalizedStringKey(appAlert.title))
      .font(.title3)
      .fontWeight(.semibold)
      .foregroundStyle(Color.appTheme.text)
  }

  var messageView: some View {
    Text(LocalizedStringKey(appAlert.message))
      .foregroundStyle(Color.appTheme.secondaryText)
      .multilineTextAlignment(.center)
  }

  var actionButtons: some View {
    HStack(spacing: 5) {
      if let actionButton = appAlert.actionButton {
        cancelButtonView
        Text(LocalizedStringKey(actionButton.title))
          .primaryButton()
          .button(.press) {
            actionButton.action()
            dismiss()
          }
      } else if let textFieldConfig = appAlert.textFieldConfig {
        cancelButtonView
        Text(LocalizedStringKey("OK"))
          .primaryButton()
          .button(.press) {
            textFieldConfig.completion(inputText)
            dismiss()
          }
      } else {
        okButtonView
      }
    }
  }

  var okButtonView: some View {
    Text(LocalizedStringKey("OK"))
      .primaryButton()
      .button(.press) {
        dismiss()
      }
  }

  var cancelButtonView: some View {
    Text("Cancel")
      .plainButton()
      .button(.press) {
        dismiss()
      }
  }

  @ViewBuilder
  var textFieldView: some View {
    if let textFieldConfig = appAlert.textFieldConfig {
      VStack(spacing: 0) {
        TextField("", text: $inputText, prompt: Text(textFieldConfig.placeholder))
          .foregroundStyle(Color.appTheme.text)
          .frame(height: 24)
          .focused($focusedField, equals: Field.nameField)
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(Color.appTheme.divider)
      }
      .padding()
    }
  }
}

private struct Preview: View {
  @State private var simpleAlert: AppAlert? = .mock1
  @State private var customActionAlert: AppAlert? = .mock2
  @State private var alertWithTextField: AppAlert? = .mock3

  var body: some View {
    VStack(spacing: 20) {
      AlertView(alert: $simpleAlert)
      AlertView(alert: $customActionAlert)
      AlertView(alert: $alertWithTextField)
    }
    .infinityFrame()
    .background(Color.appTheme.info)
  }
}

#Preview {
  Preview()
}
