//
//  ListLoader.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

class ShoppingListStore: ObservableObject {
    
    static let sharedInstance = ShoppingListStore()
    
    @Published var shoppingLists = [ShoppingList]()
    
    private let TIMER: Double = 60
    private var timer: Timer?
    private let service = ShoppingListService.sharedInstance
    private let userDefaults = UserDefaults(suiteName: "group.ch.hslu.ios.team1.shoplr")
    
    private var listIds: [String] {
        get{
            return userDefaults?.array(forKey: "ShoppingListIds") as? [String] ?? [String]()
        }
        set {
            userDefaults?.set(newValue,forKey: "ShoppingListIds")
        }
    }
    
    // MARK: Initialization
    
    private init() {
        timer = Timer.scheduledTimer(timeInterval: TIMER,
                                     target: self,
                                     selector: #selector(refreshShoppingList),
                                     userInfo: nil, repeats: true)
        listIds.forEach { id in
            print(id)
            service.getShoppingListFromEndpoint(listId: id){shoppingList in
                self.updateShoppingList(shoppingList:shoppingList)
            }
        }
    }
    
    // MARK: ShoppingList / Item Actions
    
    public func deleteShoppingList(indexSet: IndexSet) {
        for i in indexSet {
            service.deleteShoppingListOnEndpoint(listId: (shoppingLists[i]).id.uuidString)
            if let listIdIndex = listIds.firstIndex(of: shoppingLists[i].id.uuidString) {
                listIds.remove(at: listIdIndex)
                userDefaults?.setValue(listIds, forKey: "ShoppingListIds")
            }
        }
        shoppingLists.remove(atOffsets: indexSet)
    }
    
    public func createShoppingList(shoppingList: ShoppingList) {
        service.createShoppingListOnEndpoint(list: shoppingList)
        shoppingLists.append(shoppingList)
        listIds.append(shoppingList.id.uuidString)
        userDefaults?.setValue(listIds, forKey: "ShoppingListIds")
    }
    
    public func addShoppingListId(id: String) {
        listIds.append(id)
        service.getShoppingListFromEndpoint(listId: id){shoppingList in
            self.updateShoppingList(shoppingList: shoppingList)
            
        }
    }
    
    public func addItemToShoppingList(item: Item, shoppingList: ShoppingList) {
        service.addItemToShoppingListOnEndpoint(listId: shoppingList.id.uuidString, item: item)
        let idx = shoppingLists.firstIndex(of: shoppingList)
        self.shoppingLists[idx!].items.append(item)
    }
    
    public func toggleBoughtStateofItem(item: Item, shoppingList: ShoppingList){
        let idx = shoppingLists.firstIndex(of: shoppingList)
        let list = self.shoppingLists[idx!]
        if let itemIdx = list.items.firstIndex(of: item) {
            list.items[itemIdx].bought.toggle()
            service.updateShoppingListItemOnEndpoint(listId: shoppingList.id.uuidString, item: list.items[itemIdx])
        }
    }
    
    public func cleanUpBoughtItems(shoppingList: ShoppingList) {
        let idx = shoppingLists.firstIndex(of: shoppingList)
        let list = self.shoppingLists[idx!]
        for item in list.items {
            if(item.bought) {
                service.deleteShoppingListItemOnEndpoint(itemId: item.id.uuidString, listId: list.id.uuidString)
                let itemIdx = list.items.firstIndex(of: item)!
                list.items.remove(at: itemIdx)
            }
        }
    }
    
    @objc private func refreshShoppingList() {
        listIds.forEach { id in
            service.getShoppingListFromEndpoint(listId: id){list in
                self.updateShoppingList(shoppingList: list)
            }
            
        }
    }
    
    private func updateShoppingList(shoppingList: ShoppingList) {
        DispatchQueue.main.async {
            if let oldList = self.shoppingLists.filter({ $0.id == shoppingList.id}).first {
                if (oldList != shoppingList) {
                    let idx = self.shoppingLists.firstIndex(of: oldList)
                    self.shoppingLists.remove(at: idx!)
                    self.shoppingLists.append(shoppingList)
                }
            } else {
                self.shoppingLists.append(shoppingList)
            }
        }
    }
}
