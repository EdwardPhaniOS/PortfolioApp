//
//  Award.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 20/4/25.
//

import Foundation

struct Award: Identifiable, Decodable {
    var id: String { name }
    var name: String
    var description: String
    var color: String
    var criterion: String
    var value: Int
    var image: String
    
    static let allAwards = Bundle.main.decode(file: "Awards.json", asType: [Award].self)
    static let example = allAwards[0]
}
