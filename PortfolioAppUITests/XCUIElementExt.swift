//
//  XCUIElementExt.swift
//  PortfolioAppUITests
//
//  Created by Vinh Phan on 26/5/25.
//

import XCTest

extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUI element: \(self)")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}
