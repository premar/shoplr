//
//  ItemListWidgetView.swift
//  ShoplrWidgetExtension
//
//  Created by Oliver on 06.12.20.
//

import SwiftUI

struct ItemListWidgetView: View {
    let items: [Item]
    var body: some View {
        HStack(alignment:.top){
            if(items.count > 4){
                VStack(alignment:.leading){
                    
                    ForEach(0..<4) { index in
                        HStack(spacing:0) {
                            ItemWithLabelView(item: items[index])
                        }
                    }
                    
                }
                VStack(alignment:.leading){
                    
                    if(items.count>8){
                        ForEach(4..<7) { index in
                            HStack(spacing:0) {
                                ItemWithLabelView(item: items[index])
                            }
                            
                        }
                        Text("...").padding(.leading,19)
                        
                    }else{
                        ForEach(4..<items.count) { index in
                            ItemWithLabelView(item: items[index])
                        }
                    }
                }
            }else{
                VStack(alignment:.leading){
                    
                    ForEach(items) { item in
                        ItemWithLabelView(item: item)
                    }
                    
                }
            }
            
        }.font(.system(size: 14))
    }
}

struct ItemWithLabelView: View {
    let item: Item
    var body: some View {
        if item.bought {
        Label(
            title: { Text(item.name).fontWeight(.light).strikethrough() },
            icon: {Image(systemName: "checkmark.circle").scaleEffect(0.5) }
        )
        }else {
            Label(
                title: { Text(item.name).fontWeight(.light) },
                icon: {Image(systemName: "circle").scaleEffect(0.5) }
            )
        }
    }
    
}
struct ItemListWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListWidgetView(items:[
                           Item(name: "Apples", specification: "10", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Cheese", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Chips", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Coke", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Beer", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Fish", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Tea", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Steak", specification: "1", icon: "", expiryDate: Date(), bought: false),
                           Item(name: "Tomatos", specification: "1", icon: "", expiryDate: Date(), bought: false)
                       ])
    }
}
