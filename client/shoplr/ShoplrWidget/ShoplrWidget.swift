//
//  ShoplrWidget.swift
//  ShoplrWidget
//
//  Created by Oliver on 26.11.20.

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    let store = ShoppingListStore.sharedInstance
    
    private var listIds: [String]{
        get{
            // UserDefaults.standard.stringArray(forKey: "ShoppingListIds") ?? [String]()
            let userDefaults = UserDefaults(suiteName: "group.ch.hslu.ios.team1.shoplr")
            return userDefaults?.array(forKey: "ShoppingListIds") as? [String] ?? [String]()
        }
    }
    
    func placeholder(in context: Context) -> ShoplrWidgetEntry {
        ShoplrWidgetEntry(date: Date(),shoppingList: ShoppingList( name: "Einkaufslsite", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: Date(), bought: false)]))
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ShoplrWidgetEntry) -> ()) {

//        if let id = listIds.first {
//            let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
//            //list = receiveDataFromEndpoint(url: "/v1/list/\(id)/", body: nil, method: "GET")
//            fetchShoppingListData(url: "/v1/list/\(id)/") { (shoppingList) in
//                let entry = ShoplrWidgetEntry(date: entryDate, shoppingList: shoppingList)
//                print("Snapshot" + shoppingList.name)
//                completion(entry)
//
//            }
//        }
        let entry = ShoplrWidgetEntry(date: Date(),shoppingList: ShoppingList( name: "Einkaufslsite", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: Date(), bought: false)]))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoplrWidgetEntry>) -> ()) {
        var entries: [ShoplrWidgetEntry] = []
        listIds.forEach({id in print(id)})
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        
        for (index, id) in listIds.enumerated() {
            let entryDate = Calendar.current.date(byAdding: .minute, value: index+1, to: currentDate)!
            //list = receiveDataFromEndpoint(url: "/v1/list/\(id)/", body: nil, method: "GET")
            fetchShoppingListData(url: "/v1/list/\(id)/") { (shoppingList) in
                let entry = ShoplrWidgetEntry(date: entryDate, shoppingList: shoppingList)
                print(shoppingList.name)
                entries.append(entry)
                
            }
        }
        print("completion to be called now")
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
    
    
    //TODO should be called from central webservice class
    func fetchShoppingListData(url: String, completionHandler: @escaping (ShoppingList) -> Void) {
        let endpoint = URL(string: "https://shoplr.nexit.ch" + url)!
        
        var request = URLRequest(url: endpoint)
        
        request.httpMethod = "GET"
        request.setValue("1234", forHTTPHeaderField: "Authorization")
    
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do{
                let list =  try JSONDecoder().decode(ShoppingList.self, from: data)
                completionHandler(list)
            }
            catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
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


