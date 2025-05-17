//
//  AwardTests.swift
//  PortfolioAppTests
//
//  Created by Vinh Phan on 17/5/25.
//

import CoreData
import XCTest
@testable import PortfolioApp

class AwardTests: BaseTestCase {

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Expect award ID always match its name.")
        }
    }

    func testNewUserHasUnlockedNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "Expect new users has unlocked no award")
        }
    }

    func testCreatingIssueUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var issues = [Issue]()

            for _ in 0..<value {
                let issue = Issue(context: managedObjectContext)
                issues.append(issue)
            }

            let expectedAwardCount = count + 1
            let actualAwardCount = awards.filter { award in
                award.criterion == "issues" && dataController
                    .hasEarned(award: award)
            }.count

            XCTAssertEqual(expectedAwardCount,
                           actualAwardCount,
                           "Expect adding \(value) issue(s) unlock \(expectedAwardCount) award(s)")

            for issue in issues {
                dataController.delete(issue)
            }
        }
    }

}
