//
//  PortfolioAppTests.swift
//  PortfolioAppTests
//
//  Created by Vinh Phan on 14/5/25.
//

import CoreData
import XCTest
@testable import PortfolioApp

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    let awards = Award.allAwards

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
