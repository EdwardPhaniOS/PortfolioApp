//
//  PortfolioWidgetBundle.swift
//  PortfolioWidget
//
//  Created by Vinh Phan on 29/12/25.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgetBundle: WidgetBundle {
  var body: some Widget {
    SimplePortfolioWidget()
    ComplexPortfolioWidget()
  }
}
