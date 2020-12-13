//
//  ShoppingList.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation


class ShoppingList: ObservableObject, Identifiable, Hashable, Equatable, Codable{
    
    let id: UUID
    let name: String
    let icon: String
    
    @Published
    var items = [Item]()
    
    init(name: String, icon: String ) {
        self.name = name
        self.icon = icon
        self.id  = UUID()
    }
    
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
    
    //MARK: - Protocol Overrides
    //needed to implement required init to conform to Decodable while still using @Published
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        icon = try values.decode(String.self, forKey: .icon)
        items = try values.decode([Item].self, forKey: .items)
       
    }
    
    //needed to implement encode to conform to Encodable while still using @Published
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(items, forKey: .items)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case items
    }
    
    static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
        lhs.name==rhs.name && lhs.id == rhs.id && lhs.icon == rhs.icon && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(icon)
        hasher.combine(items)
    }
}
