//
//  Article.swift
//  shoplr
//
//  Created by Oliver on 17.11.20.
//

import Foundation


class Item: Identifiable, Hashable, Equatable, Codable {

    var id = UUID()
    let name: String
    let specification: String
    //TODO do we also want icon on article?
    let icon: String
    let expiryDate: Date
    var bought: Bool
    
    init( name: String, specification: String, icon: String, expiryDate: Date, bought: Bool) {
        self.name = name
        self.specification = specification
        self.icon = icon
        self.expiryDate = expiryDate
        self.bought = bought
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.name==rhs.name && lhs.id == rhs.id && lhs.specification == rhs.specification && lhs.expiryDate == rhs.expiryDate && lhs.bought == rhs.bought
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(name)
            hasher.combine(icon)
        hasher.combine(specification)
        hasher.combine(expiryDate)
        hasher.combine(bought)
    }
}
