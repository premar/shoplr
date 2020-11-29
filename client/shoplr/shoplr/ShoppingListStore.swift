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
    
    private func getListFromServer(listId: String) {
        let url = URL(string: ENDPOINT + "/v1/list/\(listId)/")!
        var request = URLRequest(url: url)
                
        request.httpMethod = "GET"
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                // TODO handle data
                let list = try! JSONDecoder().decode([ShoppingList].self, from: data)
                print(list)
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
    
    private func addItemToServer(listId: String, item: Item) {
        let url = URL(string: ENDPOINT + "/v1/item/\(listId)/")!
        var request = URLRequest(url: url)
        
        let body = try! JSONEncoder().encode(item)
        
        request.httpMethod = "POST"
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                // TODO handle data
                print(data)
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
    
    private func addListToServer(list: ShoppingList) {
        let url = URL(string: ENDPOINT + "/v1/list/")!
        var request = URLRequest(url: url)
        
        let body: [String: Any] = [
            "name": list.name,
            "icon": list.icon,
            "uuid": list.id.uuidString
        ]
        
        request.httpMethod = "POST"
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                // TODO handle data
                print(data)
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
    
    private func deleteItemOnServer(itemId: String, listId: String) {
        let url = URL(string: ENDPOINT + "/v1/item/\(listId)/\(itemId)")!
        var request = URLRequest(url: url)
                
        request.httpMethod = "DELETE"
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                // TODO handle data
                print(data)
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
    
    private func deleteListOnServer(listId: String) {
        let url = URL(string: ENDPOINT + "/v1/list/\(listId)/")!
        var request = URLRequest(url: url)
                
        request.httpMethod = "DELETE"
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                // TODO handle data
                print(data)
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
}
