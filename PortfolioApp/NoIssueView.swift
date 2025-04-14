//
//  NoIssueView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 28/3/25.
//

import SwiftUI

struct NoIssueView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Issue", action: dataController.newIssue)
    }
}

#Preview {
    NoIssueView().environmentObject(DataController.preview)
}
