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
    
    @Published var shoppingLists =  [ShoppingList]()
    
    init() {
        getListFromServer(listId: "DAD92F80-B46F-4A14-B714-C6B06C117771")
    }
        
    // MARK: - Shoppinglist actions
    public func removeList(index: IndexSet){
        shoppingLists.remove(atOffsets: index)
    }
    
    public func createShoppingList(shoppingList:ShoppingList){
        shoppingLists.append(shoppingList)
    }
    
    // MARK: - Item actions
    public func addItemToShoppingList(item: Item, shoppingList: ShoppingList){
        print("addItemToShoppingList\(item) \(shoppingList)")
        let idx = shoppingLists.firstIndex(of: shoppingList)
        self.shoppingLists[idx!].items!.append(item)
        print(self.shoppingLists[idx!].items!)
    }
    
    public func toggleBoughtStateofItem(item: Item, shoppingList:ShoppingList){
        print("toggleBoughtStateofItem \(item) \(shoppingList)")
    }
    
    public func cleanUpBoughtItems(shoppingList: ShoppingList){
        print("cleanUpBoughtItems \(shoppingList)")
    }
    
    private func getListFromServer(listId: String) {
        receiveDataFromEndpoint(url: "/v1/list/\(listId)/", body: nil, method: "GET")
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
        let endpoint = URL(string: ENDPOINT + url)!
        var request = URLRequest(url: endpoint)
                
        request.httpMethod = method
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        if(data != nil) {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
    
    private func receiveDataFromEndpoint(url: String, body: Data!, method: String) {
        let endpoint = URL(string: ENDPOINT + url)!
        var request = URLRequest(url: endpoint)
    
        request.httpMethod = method
        request.setValue(KEY, forHTTPHeaderField: "Authorization")
        
        if(body != nil) {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // TODO handle error
                print(error)
            } else if let data = data {
                print(data)
                let list =  try! JSONDecoder().decode(ShoppingList.self, from: data)
                DispatchQueue.main.async {
                    self.shoppingLists.append(list)
                }
            } else {
                // TODO handle exception
                print("Exception")
            }
        }
        task.resume()
    }
}
