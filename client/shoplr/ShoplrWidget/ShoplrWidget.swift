//
//  ShoplrWidget.swift
//  ShoplrWidget
//
//  Created by Oliver on 26.11.20.

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    let service = ShoppingListService.sharedInstance
    
    private var listIds: [String]{
        get{
            // UserDefaults.standard.stringArray(forKey: "ShoppingListIds") ?? [String]()
            let userDefaults = UserDefaults(suiteName: "group.ch.hslu.ios.team1.shoplr")
            return userDefaults?.array(forKey: "ShoppingListIds") as? [String] ?? [String]()
        }
    }
    
    func placeholder(in context: Context) -> ShoplrWidgetEntry {
        ShoplrWidgetEntry(date: Date(),shoppingList: ShoppingList( name: "Einkaufsliste", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: Date(), bought: false)]))
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ShoplrWidgetEntry) -> ()) {
        let entry = ShoplrWidgetEntry(date: Date(),shoppingList: ShoppingList( name: "Einkaufsliste", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: Date(), bought: false)]))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoplrWidgetEntry>) -> ()) {
        var entries: [ShoplrWidgetEntry] = []
        listIds.forEach({id in print(id)})
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        for (index, id) in listIds.enumerated() {
            let entryDate = Calendar.current.date(byAdding: .minute, value: index+1, to: currentDate)!
            //list = receiveDataFromEndpoint(url: "/v1/list/\(id)/", body: nil, method: "GET")
            print("should now call")
            service.getShoppingListFromEndpoint(listId: id){ (shoppingList) in
                print("hi: " + shoppingList.name)
                let entry = ShoplrWidgetEntry(date: entryDate, shoppingList: shoppingList)
                entries.append(entry)

            }
        }
        //TODO fix waiting 
        while(entries.count < 1){
            print("waiting")
            print(entries)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
struct ShoplrWidgetEntry: TimelineEntry {
    let date: Date
    var shoppingList: ShoppingList
}


@main
struct ShoplrWidget: Widget {
    let kind: String = "ShoplrWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ShoplrWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Shoplr Einkaufsliste")
        .description("Deine Einkaufsliste auf einen Blick")
    }
}


