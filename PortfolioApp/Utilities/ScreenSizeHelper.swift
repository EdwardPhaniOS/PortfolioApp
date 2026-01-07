//
//  ScreenSizeHelper.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 7/1/26.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#endif

struct ScreenSizeHelper {
    static var screenBounds: CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #elseif os(macOS)
        return NSScreen.main?.frame ?? .zero
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenBounds
        #endif
    }
    
    static var screenWidth: CGFloat {
        return screenBounds.width
    }
    
    static var screenHeight: CGFloat {
        return screenBounds.height
    }
}
