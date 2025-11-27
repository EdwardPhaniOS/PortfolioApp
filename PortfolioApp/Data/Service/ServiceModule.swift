//
//  ServiceModule.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 27/11/25.
//

import Foundation

struct ServiceModule: DIModule {
  func load(into container: DIContainer) {
    container.register(type: CoreDataStack.self, lifeTime: .singleton) { _ in
      CoreDataStack()
    }

    container.register(type: BaseService.self, lifeTime: .singleton) { resolver in
      let coreDataStack = resolver.resolve(type: CoreDataStack.self)
      return BaseService(coreDataStack: coreDataStack)
    }

    container.register(type: AwardService.self, lifeTime: .singleton) { resolver in
      let coreDataStack = resolver.resolve(type: CoreDataStack.self)
      return AwardService(coreDataStack: coreDataStack)
    }

    container.register(type: TagService.self, lifeTime: .singleton) { resolver in
      let coreDataStack = resolver.resolve(type: CoreDataStack.self)
      return TagService(coreDataStack: coreDataStack)
    }

    container.register(type: IssueService.self, lifeTime: .singleton) { resolver in
      let coreDataStack = resolver.resolve(type: CoreDataStack.self)
      return IssueService(coreDataStack: coreDataStack)
    }
  }
  
}
