//
//  ScreenSizeHelper.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 7/1/26.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct ScreenSizeHelper {
  static var screenWidth: CGFloat {
#if os(iOS)
    UIScreen.main.bounds.width
#else
    NSScreen.main?.frame.width ?? 0
#endif
  }
  
  static var screenHeight: CGFloat {
#if os(iOS)
    UIScreen.main.bounds.height
#else
    NSScreen.main?.frame.height ?? 0
#endif
  }
}
