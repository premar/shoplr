//
//  AddArticleModalView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation
import SwiftUI

struct AddItemModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    
    @State private var itemName = ""
    @State private var specification = ""
    @State private var validUntil = Date()
    
    @State private var dateWasChanged = false
    
    var shoppingList: ShoppingList
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    TextField("Listen Name" ,text: $itemName).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Specification" ,text: $specification).textFieldStyle(RoundedBorderTextFieldStyle())
                    DatePicker(selection: $validUntil, displayedComponents: .date) {
                        Text("Brauch ich bis:")
                    }.padding(.vertical)
                    .onChange(of: validUntil, perform: { value in
                        dateWasChanged = true
                    })
                }.padding()
                
                .navigationBarTitle(Text("Neuen Artikel hinzufügen"), displayMode: .inline)
                .navigationBarItems(leading:
                                        Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                                            Text("Cancel")
                                        },trailing:
                                            Button(action: {addItemToShoppingList()}) {
                                                Text("Add")
                                            })
            }}
    }
    private func addItemToShoppingList() {
        var tmpDate: Date?
        
        if(!dateWasChanged) {
            tmpDate = nil
        } else {
            tmpDate = self.validUntil
        }
        
        shoppingListStore.addItemToShoppingList(item: Item(name: self.itemName, specification: self.specification, icon: "", expiryDate: tmpDate, bought: false), shoppingList: self.shoppingList)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
struct AddItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemModalView(shoppingList: ShoppingList( name: "Einkaufslsite", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: nil, bought: false)]))
    }
}
