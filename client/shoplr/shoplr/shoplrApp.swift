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
                let userDefaults = UserDefaults(suiteName: "group.ch.hslu.ios.team1.shoplr")
                userDefaults?.set(id,forKey: "ShoppingListIds")
            }
        }
    }
}
