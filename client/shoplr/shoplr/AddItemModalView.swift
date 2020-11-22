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
    var shoppingList: ShoppingList
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading) {
                    TextField("Listen Name" ,text: $itemName).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Specification" ,text: $specification).textFieldStyle(RoundedBorderTextFieldStyle())
                    DatePicker(selection: $validUntil, in: Date()..., displayedComponents: .date) {
                        Text("Brauch ich bis:")
                    }.padding(.vertical)
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
    private func addItemToShoppingList(){
        shoppingListStore.addItemToShoppingList(item: Item(name: self.itemName, specification: self.specification, icon: "", expiryDate: self.validUntil, bought: false), shoppingList: self.shoppingList)
        self.presentationMode.wrappedValue.dismiss()
    }
}
struct AddItemModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemModalView(shoppingList: ShoppingListStore().shoppingLists![1])
    }
}
