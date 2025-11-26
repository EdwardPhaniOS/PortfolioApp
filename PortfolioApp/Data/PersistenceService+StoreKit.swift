//
//  DataController-StoreKit.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 21/6/25.
//

import Foundation
import StoreKit

extension PersistenceService {

    static let unlockPremiumProductId = "VinhPhan.PortfolioApp.premiumUnlock"

    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }

        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }

    @MainActor
    func finalize(_ transaction: Transaction) async {
        if transaction.productID == Self.unlockPremiumProductId {
            objectWillChange.send()
            fullVersionUnlocked = transaction.revocationDate == nil
            await transaction.finish()
        }
    }
}
