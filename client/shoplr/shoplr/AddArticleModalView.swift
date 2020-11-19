//
//  AddArticleModalView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation
import SwiftUI

struct AddArticleModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    
    @State private var articleName = ""
    @State private var validUntil = Date()
    var shoppingList: ShoppingList
    var body: some View {
        NavigationView{
            Form{
            VStack(alignment: .leading) {
                TextField("Listen Name" ,text: $articleName).textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker(selection: $validUntil, in: Date()..., displayedComponents: .date) {
                                Text("Brauch ich bis:")
                }.padding(.vertical)
            }.padding()

            .navigationBarTitle(Text("Neuen Artikel hinzufügen"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                                        Text("Cancel")
                                    },trailing:
                                        Button(action: {addNewArticleToList()}) {
                                            Text("Add")
                                        })
            }}
    }
    private func addNewArticleToList(){
        
    }
}
struct AddArticleModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddArticleModalView(shoppingList: ShoppingListStore().shoppingLists![1])
    }
}
