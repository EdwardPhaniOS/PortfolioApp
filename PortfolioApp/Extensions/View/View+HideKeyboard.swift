//
//  View+hideKeyboard.swift
//  UberClone
//
//  Created by Vinh Phan on 13/11/25.
//

import SwiftUI

extension View {
  func hideKeyboardOnTap() -> some View {
    self.onTapGesture {
      hideKeyboard()
    }
  }
  
  func hideKeyboard() {
#if os(iOS)
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
  }
}
