//
//  ToolbarItemPlacement.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 7/1/26.
//

import SwiftUI

extension ToolbarItemPlacement {
#if os(watchOS)
  static let automaticOrLeading = ToolbarItemPlacement.topBarLeading
  static let automaticOrTrailing = ToolbarItemPlacement.topBarTrailing
#else
  static let automaticOrLeading = ToolbarItemPlacement.automatic
  static let automaticOrTrailing = ToolbarItemPlacement.automatic
#endif
}
