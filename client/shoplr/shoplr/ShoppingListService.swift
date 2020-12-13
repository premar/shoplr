//
//  ShoppingListService.swift
//  shoplr
//
//  Created by Oliver on 07.12.20.
//

import Foundation

final class ShoppingListService {
    
    static let sharedInstance = ShoppingListService()
    private init() {}
    
    private let KEY: String = "1234"
    private let ENDPOINT: String = "https://shoplr.nexit.ch"
    
    // MARK: Endpoint Actions
    public  func getShoppingListFromEndpoint(listId: String, completion: @escaping (ShoppingList) -> ()) {
        receiveShoppingListFromEndpoint(url: "/v1/list/\(listId)/", body: nil, method: "GET"){list in
            completion(list)
        }
    }
    
    public  func addItemToShoppingListOnEndpoint(listId: String, item: Item) {
        let data = try? JSONEncoder().encode(item)
        sendRequestToEndpoint(url: "/v1/item/\(listId)/", data: data, method: "POST")
    }
    
    public func updateShoppingListItemOnEndpoint(listId: String, item: Item) {
        let data = try? JSONEncoder().encode(item)
        sendRequestToEndpoint(url: "/v1/item/\(listId)/", data: data, method: "PUT")
    }
    
    public func createShoppingListOnEndpoint(list: ShoppingList) {
        let body: [String: Any] = [
            "name": list.name,
            "icon": list.icon,
            "id": list.id.uuidString
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        sendRequestToEndpoint(url: "/v1/list/", data: data, method: "POST")
    }
    
    public func deleteShoppingListItemOnEndpoint(itemId: String, listId: String) {
        sendRequestToEndpoint(url: "/v1/item/\(listId)/\(itemId)/", data: nil, method: "DELETE")
    }
    
    public func deleteShoppingListOnEndpoint(listId: String) {
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
                print(error)
            } else if let data = data {
                print(data)
            } else {
                print("Exception in sendRequestToEndpoint")
            }
        }
        task.resume()
    }
    
    private func receiveShoppingListFromEndpoint(url: String, body: Data!, method: String, completion: @escaping (ShoppingList) -> ()) {
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
                print(error)
            } else if let data = data {
                let list = try? JSONDecoder().decode(ShoppingList.self, from: data)
                if let list = list {completion(list)}
            } else {
                print("Exception in receiveShoppingListFromEndpoint")
            }
        }
        task.resume()
    }
}
