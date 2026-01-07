//
//  View+NavigationBar.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 7/1/26.
//

import SwiftUI

extension View {
  func inlineNavigationBar() -> some View {
#if os(macOS)
    self
#else
    self.navigationBarTitleDisplayMode(.inline)
#endif
  }
}
