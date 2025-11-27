////
////  DevelopmentTests.swift
////  PortfolioAppTests
////
////  Created by Vinh Phan on 17/5/25.
////
//
//import XCTest
//import CoreData
//@testable import PortfolioApp
//
//class DevelopmentTests: BaseTestCase {
//
//    func testCreateSampleDataWorks() {
//        dataController.createSampleData()
//
//        XCTAssertEqual(5, dataController.count(request: Tag.fetchRequest()), "Expected 5 tags but found \(dataController.count(request: Tag.fetchRequest())).")
//        XCTAssertEqual(50, dataController.count(request: Issue.fetchRequest()), "Expected 50 issues but found \(dataController.count(request: Issue.fetchRequest())).")
//    }
//
//    func testDeleteAllClearsEverything() {
//        dataController.createSampleData()
//        dataController.deleteAll()
//
//        XCTAssertEqual(0, dataController.count(request: Tag.fetchRequest()), "Expected 0 tags but found \(dataController.count(request: Tag.fetchRequest())).")
//        XCTAssertEqual(0, dataController.count(request: Issue.fetchRequest()), "Expected 0 issues but found \(dataController.count(request: Issue.fetchRequest())).")
//    }
//
//    func testExampleTagHasNoIssues() {
//        let tag = Tag.example
//
//        XCTAssertEqual(
//            0,
//            tag.issues?.count,
//            "Expected 0 issues from example tag but found \(tag.issues?.count ?? -1) issue(s)."
//        )
//    }
//
//    func testExampleIssueIsHighPriority() {
//        let issue = Issue.example
//        XCTAssertEqual(issue.priority, 2, "Expected example issue priority to be 2 but found it to be \(issue.priority)")
//    }
//}
