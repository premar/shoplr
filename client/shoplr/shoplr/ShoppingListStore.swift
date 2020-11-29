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
        let data = receiveDataFromEndpoint(url: "/v1/list/\(listId)/", data: nil, method: "GET")!
        let list = try! JSONDecoder().decode([ShoppingList].self, from: data)
    }
    
    private func addItemToServer(listId: String, item: Item) {
        let data = try! JSONEncoder().encode(item)
        sendRequestToEndpoint(url: "/v1/item/\(listId)/", data: data, method: "POST")
    }
    
    private func addListToServer(list: ShoppingList) {
        let body: [String: Any] = [
            "name": list.name,
            "icon": list.icon,
            "uuid": list.id.uuidString
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        sendRequestToEndpoint(url: "/v1/list/", data: data, method: "POST")
    }
    
    private func deleteItemOnServer(itemId: String, listId: String) {
        sendRequestToEndpoint(url: "/v1/item/\(listId)/\(itemId)", data: nil, method: "DELETE")
    }
    
    private func deleteListOnServer(listId: String) {
        sendRequestToEndpoint(url: "/v1/list/\(listId)/", data: nil, method: "DELETE")
    }
    
    private func sendRequestToEndpoint(url: String, data: Data!, method: String) {
        let endpoint = URL(string: ENDPOINT + "/\(url)")!
        var request = URLRequest(url: endpoint)
                
        request.httpMethod = method
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        if(data != nil) {
            request.httpBody = data
        }
        
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
    
    // Best Option?
    // Callback Function
    // NSLoock
    // DispatchSemaphore
    private func receiveDataFromEndpoint(url: String, data: Data!, method: String) -> Data? {
        let endpoint = URL(string: ENDPOINT + "/\(url)")!
        let lock = NSLock()
        var request = URLRequest(url: endpoint)
        
                
        request.httpMethod = method
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        if(data != nil) {
            request.httpBody = data
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                print(data)
            } else {
                // TODO handle exception
                print("Exception")
            }
            lock.unlock()
        }
        task.resume()
        lock.lock()
        return data
    }
}
