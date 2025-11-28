//
//  SmartFilterRow.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 5/5/25.
//

import SwiftUI

struct SmartFilterRow: View {

    var filter: Filter

    var body: some View {
        NavigationLink(value: filter) {
          Label(filter.name.localizedStringKey, systemImage: filter.icon)
        }
    }
}

#Preview {
    SmartFilterRow(filter: .all)
}
