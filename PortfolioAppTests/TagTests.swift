//
//  TagTests.swift
//  PortfolioAppTests
//
//  Created by Vinh Phan on 16/5/25.
//

import CoreData
import XCTest
@testable import PortfolioApp

class TagTests: BaseTestCase {

    func testCreatingTagsAndIssues() {
        let count = 10
        let issueCount = count * count

        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<count {
                let issue = Issue(context: managedObjectContext)
                issue.addToTags(tag)
            }
        }

        XCTAssertEqual(
            count,
            dataController.count(request: Tag.fetchRequest()),
            "Expected \(count) tags, found \(dataController.count(request: Tag.fetchRequest()))"
        )

        XCTAssertEqual(
            issueCount,
            dataController.count(request: Issue.fetchRequest()),
            "Expected \(issueCount) issues, found \(dataController.count(request: Issue.fetchRequest()))"
        )
    }

    func testDeletingTagDoesNotDeleteIssues() throws {
        dataController.createSampleData()

        let tags = try managedObjectContext.fetch(Tag.fetchRequest())
        dataController.delete(tags[0])

        XCTAssertEqual(4, dataController.count(request: Tag.fetchRequest()), "Expected 4 tags after deleting 1 tag")
        XCTAssertEqual(50, dataController.count(request: Issue.fetchRequest()), "Expected 50 issues after deleting a tag")
    }


}
