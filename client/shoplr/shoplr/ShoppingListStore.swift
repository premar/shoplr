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
    private let TIMER: Double = 60
    
    private var timer: Timer?
    private var listIds: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "ShoppingListIds") ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue,forKey: "ShoppingListIds")
        }
    }
        
    @Published var shoppingLists = [ShoppingList]()
    
    // MARK: Initialization
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: TIMER, target: self, selector: #selector(updateShoppingList), userInfo: nil, repeats: true)
        
        listIds.forEach { id in
            print(id)
            getShoppingListFromEndpoint(listId: id)
        }
    }
        
    // MARK: ShoppingList / Item Actions
    
    public func deleteShoppingList(index: IndexSet) {
        // TODO: Rename index to indexSet, because it can hold more than one index
        for i in index {
            deleteShoppingListOnEndpoint(listId: (shoppingLists[i]).id.uuidString)
            // remove id from user defaults
            if let listIdIndex = listIds.firstIndex(of: shoppingLists[i].id.uuidString) {
                listIds.remove(at: listIdIndex)
            }
        }
        shoppingLists.remove(atOffsets: index)
    }
    
    public func createShoppingList(shoppingList: ShoppingList) {
        createShoppingListOnEndpoint(list: shoppingList)
        shoppingLists.append(shoppingList)
        listIds.append(shoppingList.id.uuidString)
    }
    
    public func addItemToShoppingList(item: Item, shoppingList: ShoppingList) {
        addItemToShoppingListOnEndpoint(listId: shoppingList.id.uuidString, item: item)
        print("addItemToShoppingList\(item) \(shoppingList)")
        let idx = shoppingLists.firstIndex(of: shoppingList)
        self.shoppingLists[idx!].items.append(item)
        print(self.shoppingLists[idx!].items)
    }
    
    public func toggleBoughtStateofItem(item: Item, shoppingList: ShoppingList){
        let idx = shoppingLists.firstIndex(of: shoppingList)
        let list = self.shoppingLists[idx!]
        if let itemIdx = list.items.firstIndex(of: item) {
            list.items[itemIdx].bought.toggle()
            updateShoppingListItemOnEndpoint(listId: shoppingList.id.uuidString, item: list.items[itemIdx])
        }
    }
    
    public func cleanUpBoughtItems(shoppingList: ShoppingList) {
        let idx = shoppingLists.firstIndex(of: shoppingList)
        let list = self.shoppingLists[idx!]
        for item in list.items {
            if(item.bought) {
                deleteShoppingListItemOnEndpoint(itemId: item.id.uuidString, listId: list.id.uuidString)
                let itemIdx = list.items.firstIndex(of: item)!
                list.items.remove(at: itemIdx)
            }
        }
    }
    
    @objc private func updateShoppingList() {
        listIds.forEach { id in
            getShoppingListFromEndpoint(listId: id)
        }
    }
    
    // MARK: Endpoint Actions
    
    private func getShoppingListFromEndpoint(listId: String) {
        receiveShoppingListFromEndpoint(url: "/v1/list/\(listId)/", body: nil, method: "GET")
    }
    
    private func addItemToShoppingListOnEndpoint(listId: String, item: Item) {
        let data = try! JSONEncoder().encode(item)
        sendRequestToEndpoint(url: "/v1/item/\(listId)/", data: data, method: "POST")
    }
    
    private func updateShoppingListItemOnEndpoint(listId: String, item: Item) {
        let data = try! JSONEncoder().encode(item)
        sendRequestToEndpoint(url: "/v1/item/\(listId)/", data: data, method: "PUT")
    }
    
    private func createShoppingListOnEndpoint(list: ShoppingList) {
        let body: [String: Any] = [
            "name": list.name,
            "icon": list.icon,
            "id": list.id.uuidString
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        sendRequestToEndpoint(url: "/v1/list/", data: data, method: "POST")
    }
    
    private func deleteShoppingListItemOnEndpoint(itemId: String, listId: String) {
        sendRequestToEndpoint(url: "/v1/item/\(listId)/\(itemId)", data: nil, method: "DELETE")
    }
    
    private func deleteShoppingListOnEndpoint(listId: String) {
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
                // TODO: handle error
                print(error)
            } else if let data = data {
                print(data)
            } else {
                // TODO: handle exception
                print("Exception")
            }
        }
        task.resume()
    }
    
    private func receiveShoppingListFromEndpoint(url: String, body: Data!, method: String) {
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
                // TODO: handle error
                print(error)
            } else if let data = data {
                print(data)
                let list = try? JSONDecoder().decode(ShoppingList.self, from: data)
                DispatchQueue.main.async {
                    if (list != nil) {
                        if let oldList = self.shoppingLists.filter({ $0.id == list?.id}).first {
                            if (oldList != list) {
                                let idx = self.shoppingLists.firstIndex(of: oldList)
                                self.shoppingLists.remove(at: idx!)
                                self.shoppingLists.append(list!)
                            }
                        } else {
                            self.shoppingLists.append(list!)
                        }
                    }
                }
            } else {
                // TODO: handle exception
                print("Exception")
            }
        }
        task.resume()
    }
}
