//
//  String+Ext.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 26/11/25.
//

import Foundation
import SwiftUICore

extension String {
  static var empty: String {
    return ""
  }

  var localizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}
