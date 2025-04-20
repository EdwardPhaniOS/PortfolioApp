//
//  AwardView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import SwiftUI

struct AwardView: View {
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns) {
                ForEach(Award.allAwards) { award in
                    Button {
                        //TODO:
                    } label: {
                        Image(systemName: award.image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                }
            }
        }
        .navigationTitle("Awards")
    }
}

#Preview {
    AwardView()
}
