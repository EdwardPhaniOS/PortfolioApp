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
    var persistenceService: PersistenceService!
    var managedObjectContext: NSManagedObjectContext!
    let awards = Award.allAwards

    override func setUpWithError() throws {
      persistenceService = PersistenceService.mock
      managedObjectContext = persistenceService.coreDataStack.viewContext
    }
}
