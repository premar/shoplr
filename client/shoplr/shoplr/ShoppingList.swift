//
//  ShoppingList.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

struct ShoppingList: Identifiable {
    var id = UUID()
    let name: String
    let icon: String
    var articles: [Article]
    
}
