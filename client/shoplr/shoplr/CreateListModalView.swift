//
//  CreateListModalView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import Foundation
import SwiftUI

struct CreateListModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    
    @State private var listName: String = ""
    @State private var selectIcon = 0
   
    let icons = ["🏠","❤️","😃","📚","🍺","🎷"]
    var body: some View {
        
        NavigationView{
            Form{
            VStack(alignment: .leading) {
                TextField("Listen Name" ,text: $listName).textFieldStyle(RoundedBorderTextFieldStyle())
                Picker(selection: $selectIcon, label: Text("What is your favorite color?")) {
                    ForEach(0..<icons.count) { index in
                        Text(self.icons[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)
            }.padding()

            .navigationBarTitle(Text("Neue Liste erstellen"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                                        Text("Cancel")
                                    },trailing:
                                        Button(action: {addNewList()}) {
                                            Text("Add")
                                        })
            }}}
    private func addNewList(){
        self.presentationMode.wrappedValue.dismiss()
        shoppingListStore.shoppingLists?.append(ShoppingList(name: listName, icon: icons[selectIcon]))
        
    }
}
struct CreateListModalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListModalView()
    }
}
