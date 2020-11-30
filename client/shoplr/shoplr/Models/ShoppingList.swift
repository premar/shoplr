//
//  ShoppingList.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation


class ShoppingList: Identifiable, Hashable, Equatable, Codable{

    //TODO 
    static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
        lhs.name==rhs.name && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(name)
            hasher.combine(icon)
            hasher.combine(items)
    }
    
    let id: UUID
    let name: String
    let icon: String
    var items = [Item]()
    
    init(name: String, icon: String ) {
        self.name = name
        self.icon = icon
        self.id  = UUID()
    }
    
    //TODO only used for debugging
    init(name: String, icon: String , items: [Item]) {
        self.name = name
        self.icon = icon
        self.items = items
        self.id = UUID()
    }
    
    init(name: String, icon: String , items: [Item], id: UUID) {
        self.name = name
        self.icon = icon
        self.items = items
        self.id = id
    }
}
