//
//  Article.swift
//  shoplr
//
//  Created by Oliver on 17.11.20.
//

import Foundation

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let specification: String
    //TODO do we also want icon on article?
    let icon: String
    let expiryDate: Date
    var bought: Bool
    
}
