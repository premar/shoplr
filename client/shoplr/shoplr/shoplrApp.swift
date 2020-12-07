//
//  shoplrApp.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

@main
struct shoplrApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ShoppingListStore.sharedInstance).onOpenURL { url in
                let id = url.relativeString.dropFirst(9)
                ShoppingListStore.sharedInstance.addShoppingListId(id:String(id))
            }
        }
    }
}
