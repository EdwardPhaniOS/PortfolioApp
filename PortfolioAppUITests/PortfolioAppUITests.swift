//
//  PortfolioAppUITests.swift
//  PortfolioAppUITests
//
//  Created by Vinh Phan on 24/5/25.
//

import XCTest

final class PortfolioAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        continueAfterFailure = false
    }

    @MainActor
    func testAppStartWithNavigationBar() throws {
        XCTAssert(app.navigationBars.element.exists, "Expected a navigation bar when launching the app")
    }

    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "Expected a 'Filters' button on launch")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "Expected a 'Filter' button on launch")
        XCTAssertTrue(app.navigationBars.buttons["New Issue"].exists, "Expected a 'New Issue' button on launch")
    }

    func testNoIssuesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "Expected no rows initially")
    }

    func testCreatingAndDeletingIssue() {
        for tapCount in 1...5 {
            app.buttons["New Issue"].firstMatch.tap()
            app.buttons["Issues"].firstMatch.tap()

            XCTAssertEqual(tapCount, app.cells.count, "Expected \(tapCount) rows in the list")
        }

        for expectedCellCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()

            XCTAssertEqual(expectedCellCount, app.cells.count, "Expected \(expectedCellCount) rows in the list")
        }
    }

    func testEdittingIssueTitleUpdatesCorrectly() {
        XCTAssertEqual(app.cells.count, 0, "Expected no list rows initially")

        let newIssueName = "My New Issue"

        app.buttons["New Issue"].tap()
        app.textFields["Enter the issue title here"].tap()
        app.textFields["Enter the issue title here"].clear()
        app.typeText(newIssueName)
        app.buttons["Issues"].tap()

        XCTAssertTrue(app.buttons["My New Issue"].exists, "Expected a new issue named: \(newIssueName)")
    }

    func testEdittingIssuePriorityShowIcon() {
        app.buttons["New Issue"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()

        app.buttons["Issues"].tap()

        let id = "New Issue High Priority"
        XCTAssertTrue(app.images[id].exists, "Expected an icon next to high priority issue")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            if !app.windows.firstMatch.frame.contains(award.frame) {
                app.swipeUp()
            }

            award.tap()
                      XCTAssertTrue(app.alerts["Locked"].exists, "Expected a locked alert for each award")
            app.buttons["OK"].tap()
        }
    }
}
