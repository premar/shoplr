//
//  ShoplrWidgetEntryView.swift
//  shoplr
//
//  Created by Oliver on 06.12.20.
//

import SwiftUI
import WidgetKit

struct ShoplrWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment:.leading){
            if let items = entry.shoppingList.items {
                
                HStack(alignment:.center){
                    Text(String(items.count)).font(.system(size: 22)) +
                        Text(" Artikel in ").font(.system(size: 10)) +
                        Text(entry.shoppingList.name).bold().foregroundColor(Color.green).font(.system(size: 20))
                }
                Divider()
                ItemListWidgetView(items: items)
                Divider()
            }
            
        }.padding()
        
    }
}

struct ShoplrWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ShoplrWidgetEntryView(entry: ShoplrWidgetEntry(date: Date(),shoppingList: ShoppingList( name: "Family", icon: "😃", items:[
            Item(name: "Apples", specification: "10", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Cheese", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Chips", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Coke", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Beer", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Fish", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Tea", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Steak", specification: "1", icon: "", expiryDate: Date(), bought: false),
            Item(name: "Tomatos", specification: "1", icon: "", expiryDate: Date(), bought: false)
        ])))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
