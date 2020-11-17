//
//  ShoppingListView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

struct ShoppingListView: View {
    let shoppinglist: ShoppingList
    @State private var show_modal: Bool = false
    var body: some View {
        List{
            ForEach(shoppinglist.articles){article in
                
                HStack{
                    Image(systemName: "circle")
                    Text(article.name + " (" + article.specification + ")")
                }
            }
//            .onDelete(perform: onDelete)
//            .onMove(perform: onMove)
            
            
        }.navigationBarTitle(shoppinglist.name)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        print("Button Pushed")
                                        self.show_modal = true
                                    }) {
                                        Image(systemName: "plus")
                                    }.sheet(isPresented: self.$show_modal) {
                                        AddArticleModalView()
                                    }
            )
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(shoppinglist: ListLoader().shoppingLists![1])
    }
}

