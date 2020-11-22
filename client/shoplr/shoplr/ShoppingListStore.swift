//
//  ListLoader.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

class ShoppingListStore: ObservableObject {
    @Published var shoppingLists: [ShoppingList]?
    init() {
        shoppingLists = [ShoppingList( name: "Family", icon: "😃", items: [Item(name: "Apples", specification: "10", icon: "", expiryDate: Date(), bought: false),Item(name: "Cheese", specification: "1", icon: "", expiryDate: Date(), bought: false)]),
                         ShoppingList( name: "WG", icon: "🍺", items: [Item(name: "Beer", specification: "Braufrisch", icon: "", expiryDate: Date(), bought: false), Item(name: "Chips", specification: "Zweifel", icon: "", expiryDate: Date(), bought: false)]),
                         ShoppingList( name: "Book Club", icon: "📚", items:
                                        [Item(name: "Clean Code", specification: "Rober C Martin", icon: "", expiryDate: Date(), bought: false),Item(name: "Fire and Fury", specification: "2x", icon: "", expiryDate: Date(), bought: false)])
        ]
        //        let task = URLSession.shared.dataTask(with: URL(string: "https://media.routard.com/image/83/0/photo.1536830.jpg")!){
        //            (data,_,_image) in
        //            if let image = data{
        //                DispatchQueue.main.async{
        //                        self.image = UIImage(data: image)
        //                    }
        //
        //
        //            }
        //        }
        //        task.resume()
        
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
}
