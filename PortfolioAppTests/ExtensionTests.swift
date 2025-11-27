////
////  ExtensionTests.swift
////  PortfolioAppTests
////
////  Created by Vinh Phan on 19/5/25.
////
//
//import CoreData
//import XCTest
//@testable import PortfolioApp
//
//class ExtensionTests: BaseTestCase {
//
//    func testIssueTitleUnwrap() {
//        let issue = Issue(context: managedObjectContext)
//
//        issue.title = "Example issue"
//        XCTAssertEqual("Example issue", issue.issueTitle, "Expected changing title should also change issueTitle")
//
//        issue.issueTitle = "Updated issue"
//        XCTAssertEqual("Updated issue", issue.title, "Expected changing issueTitle should also change title")
//    }
//
//    func testIssueContentUnwrap() {
//        let issue = Issue(context: managedObjectContext)
//
//        issue.content = "Example content"
//        XCTAssertEqual("Example content", issue.issueContent, "Expected changing content should also change issueContent")
//
//        issue.issueContent = "Updated content"
//        XCTAssertEqual("Updated content", issue.content, "Expected changing issueContent should also change content")
//    }
//
//    func testIssueCreationDateUnwrap() {
//        //Given
//        let issue = Issue(context: managedObjectContext)
//        let date = Date.now
//
//        //When
//        issue.creationDate = date
//
//        //Then
//        XCTAssertEqual(date, issue.issueCreationDate, "Expected changing creationDate should also change issueCreationDate")
//    }
//
//    func testIssueTagUnwrap() {
//        let issue = Issue(context: managedObjectContext)
//        let tag = Tag(context: managedObjectContext)
//
//        XCTAssertEqual(
//            issue.issueTags.count,
//            0,
//            "Expected a new issue has no tags."
//        )
//
//        issue.addToTags(tag)
//        XCTAssertEqual(
//            issue.issueTags.count,
//            1,
//            "Expected issueTags having count 1 after adding a tag to an issue."
//        )
//    }
//
//    func testIssueTagsList() {
//        let issue = Issue(context: managedObjectContext)
//        let tag = Tag(context: managedObjectContext)
//
//        tag.name = "My Tag"
//        issue.addToTags(tag)
//        XCTAssertEqual(issue.issueTagList, "My Tag", "Expected issueTagList to return the name of the added tag.")
//    }
//
//    func testIssueSortingIsStable() {
//        let issue1 = Issue(context: managedObjectContext)
//        issue1.title = "B Issue"
//        issue1.creationDate = .now
//
//        let issue2 = Issue(context: managedObjectContext)
//        issue2.title = "B Issue"
//        issue2.creationDate = .now.addingTimeInterval(1)
//
//        let issue3 = Issue(context: managedObjectContext)
//        issue3.title = "A Issue"
//        issue3.creationDate = .now.addingTimeInterval(100)
//
//        let expectedSortedIssues: [Issue] = [issue3, issue1, issue2]
//
//        let sorted = [issue1, issue2, issue3].sorted()
//        XCTAssertEqual(sorted, expectedSortedIssues, "Expected sorting issue arrays should use name then creationDate")
//    }
//
//    func testTagIDUnwrap() {
//        let tag = Tag(context: managedObjectContext)
//        let id = UUID()
//        tag.id = id
//
//        XCTAssertEqual(tag.id, tag.tagID, "Expected changing id to update tagID.")
//    }
//
//    func testTagNameUnwrap() {
//        let tag = Tag(context: managedObjectContext)
//        tag.name = "Test Tag"
//
//        XCTAssertEqual(tag.name, tag.tagName, "Expected changing name to update tagName.")
//    }
//
//    func testTagActiveIssues() {
//        let tag = Tag(context: managedObjectContext)
//        let issue = Issue(context: managedObjectContext)
//
//        XCTAssertEqual(tag.tagActiveIssues.count, 0, "Expected new tag has zero active issues")
//
//        tag.addToIssues(issue)
//        XCTAssertEqual(tag.tagActiveIssues.count, 1, "Expected new tag has one active issue after adding an issue")
//
//        issue.completed = true
//        XCTAssertEqual(tag.tagActiveIssues.count, 0, "Expected new tag with 1 completed issue will have zero active issues")
//    }
//
//    func testTagSortingIsStable() {
//        let tag1 = Tag(context: managedObjectContext)
//        tag1.name = "B Tag"
//        tag1.id = UUID()
//
//        let tag2 = Tag(context: managedObjectContext)
//        tag2.name = "B Tag"
//        tag2.id = UUID(uuidString: "FFFFFFFF-3F6D-41B6-8293-E97F9029B85C")
//
//        let tag3 = Tag(context: managedObjectContext)
//        tag3.name = "A Tag"
//        tag3.id = UUID()
//
//        let allTags = [tag1, tag2, tag3]
//        let sortedTag = allTags.sorted()
//
//        XCTAssertEqual(sortedTag, [tag3, tag1, tag2], "Expected tags to be sorted by name then by UUID string")
//    }
//
//    func testBundleDecodingAwards() {
//        let awards = Bundle.main.decode(file: "Awards.json", asType: [Award].self)
//        XCTAssertFalse(awards.isEmpty, "Expected decode to return non-empty array")
//    }
//
//    func testBundleDecodingString() {
//        let text = Bundle(for: ExtensionTests.self).decode(file: "DecodableString.json", asType: String.self)
//        XCTAssertEqual(text, "Never ask a starfish for directions.", "Expected decode result match content in DecodableString.json")
//    }
//
//    func testBundleDecodingDictionary() {
//        let dict = Bundle(for: ExtensionTests.self).decode(
//            file: "DecodableDictionary.json",
//            asType: [String: Int].self
//        )
//
//        XCTAssertEqual(dict.count, 3, "Expected decode result has 3 items")
//        XCTAssertEqual(1, dict["One"], "Expected decode result contain value 1 for the key One")
//    }
//}
