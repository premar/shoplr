//
//  Article.swift
//  shoplr
//
//  Created by Oliver on 17.11.20.
//

import Foundation


class Item: ObservableObject,Identifiable, Hashable, Equatable, Codable {

    var id = UUID()
    let name: String
    let specification: String
    let expiryDate: Date?
    @Published
    var bought: Bool
    
    init( name: String, specification: String, icon: String, expiryDate: Date?, bought: Bool) {
        self.name = name
        self.specification = specification
        self.expiryDate = expiryDate
        self.bought = bought
    }
    //MARK: - Protocol Overrides
    //needed to implement required init to conform to Decodable while still using @Published
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        specification = try values.decode(String.self, forKey: .specification)
        expiryDate = try? values.decode(Date.self, forKey: .expiryDate)
        bought = try values.decode(Bool.self, forKey: .bought)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.name==rhs.name && lhs.id == rhs.id && lhs.specification == rhs.specification && lhs.expiryDate == rhs.expiryDate && lhs.bought == rhs.bought
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(specification)
        hasher.combine(expiryDate)
        hasher.combine(bought)
    }
    
    //needed to implement encode to conform to Encodable while still using @Published
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(specification, forKey: .specification)
        try container.encode(expiryDate, forKey: .expiryDate)
        try container.encode(bought, forKey: .bought)
    }
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case specification
        case expiryDate
        case bought
    }
}
