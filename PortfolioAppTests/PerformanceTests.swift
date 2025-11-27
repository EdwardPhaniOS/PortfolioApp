////
////  PerformanceTests.swift
////  PortfolioAppTests
////
////  Created by Vinh Phan on 24/5/25.
////
//
//import XCTest
//@testable import PortfolioApp
//
//class PerformanceTests: BaseTestCase {
//
//    func testAwardCalculationPerformance() {
//        for _ in 1...100 {
//            dataController.createSampleData()
//        }
//
//        let awards = Array(repeating: Award.allAwards, count: 25).joined()
//        XCTAssertEqual(awards.count, 500, "Expected awards count is constant")
//
//        measure({
//            _ = awards.filter(dataController.hasEarned)
//        })
//    }
//}
