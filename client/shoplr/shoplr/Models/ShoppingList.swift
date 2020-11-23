//
//  ShoppingList.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

struct ShoppingList: Identifiable,Equatable {
    //TODO 
    static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
        lhs.name==rhs.name && lhs.id == rhs.id
    }
    
    var id = UUID()
    let name: String
    let icon: String
    var items: [Item]?
    
}
