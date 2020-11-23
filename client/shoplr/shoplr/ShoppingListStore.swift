//
//  ListLoader.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

class ShoppingListStore: ObservableObject {
    private let KEY: String = "1234"
    private let ENDPOINT: String = "https://shoplr.nexit.ch"
    
    @Published var shoppingLists: [ShoppingList]?
    
    init() {
        
        getListFromServer(uuid: "1234");
        
        shoppingLists = [ShoppingList( name: "Family", icon: "😃", items: [Item(name: "Apples", specification: "10", icon: "", expiryDate: Date(), bought: false),Item(name: "Cheese", specification: "1", icon: "", expiryDate: Date(), bought: false)]),
                         ShoppingList( name: "WG", icon: "🍺", items: [Item(name: "Beer", specification: "Braufrisch", icon: "", expiryDate: Date(), bought: false), Item(name: "Chips", specification: "Zweifel", icon: "", expiryDate: Date(), bought: false)]),
                         ShoppingList( name: "Book Club", icon: "📚", items:
                                        [Item(name: "Clean Code", specification: "Rober C Martin", icon: "", expiryDate: Date(), bought: false),Item(name: "Fire and Fury", specification: "2x", icon: "", expiryDate: Date(), bought: false)])
        ]
    }
    
    // MARK: - Shoppinglist actions
    public func removeList(index: IndexSet){
        shoppingLists!.remove(atOffsets: index)
    }
    
    public func createShoppingList(shoppingList:ShoppingList){
        shoppingLists?.append(shoppingList)
    }
    
    // MARK: - Item actions
    public func addItemToShoppingList(item: Item, shoppingList: ShoppingList){
        print("addItemToShoppingList\(item) \(shoppingList)")
        var idx = shoppingLists!.firstIndex(of: shoppingList)
        self.shoppingLists![idx!].items!.append(item)
        print(self.shoppingLists![idx!].items!)
    }
    
    public func toggleBoughtStateofItem(item: Item, shoppingList:ShoppingList){
        print("toggleBoughtStateofItem \(item) \(shoppingList)")
    }
    
    public func cleanUpBoughtItems(shoppingList: ShoppingList){
        print("cleanUpBoughtItems \(shoppingList)")
    }
    
    private func getListFromServer(uuid: String) {
        let parameters = ["uuid": uuid, "key" : KEY]
        var urlComponents = URLComponents(string: ENDPOINT)

        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            print(response)
        }
        task.resume()
    }
}
