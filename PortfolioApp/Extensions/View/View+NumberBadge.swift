//
//  View+NumberBadge.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 7/1/26.
//

import SwiftUI

extension View {
  
  func numberBadge(_ number: Int) -> some View {
#if os(watchOS)
    self
#else
    self.badge(number)
#endif
  }
  
}
