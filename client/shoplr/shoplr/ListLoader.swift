//
//  ListLoader.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation

class ListLoader: ObservableObject {
    @Published var shoppingLists: [ShoppingList]?
    init() {
        shoppingLists = [ShoppingList( name: "Family", icon: "person.3.fill", articles: [Article(name: "Apples", specification: "10", icon: "", expiryDate: Date()),Article(name: "Cheese", specification: "1", icon: "", expiryDate: Date())]),
                         ShoppingList( name: "WG", icon: "house.fill", articles: [Article(name: "Beer", specification: "Braufrisch", icon: "", expiryDate: Date()), Article(name: "Chips", specification: "Zweifel", icon: "", expiryDate: Date())]),
                         ShoppingList( name: "Book Club", icon: "book.fill", articles:
                                        [Article(name: "Clean Code", specification: "Rober C Martin", icon: "", expiryDate: Date()),Article(name: "Fire and Fury", specification: "2x", icon: "", expiryDate: Date())])
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
}
