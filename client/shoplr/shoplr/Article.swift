//
//  Article.swift
//  shoplr
//
//  Created by Oliver on 17.11.20.
//

import Foundation

struct Article: Identifiable {
    var id = UUID()
    let name: String
    let specification: String
    let icon: String
    let expiryDate: Date
    let bought: Bool
    
}
