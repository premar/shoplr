//
//  ShoppingListView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

struct ShoppingListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    
    var shoppingList: ShoppingList
    @State private var isAddItemModalPresented: Bool = false
    
    @State private var newItemName: String = ""
    
    var shoppingListIndex: Int?{
        shoppingListStore.shoppingLists?.firstIndex(where: {$0.id == shoppingList.id})
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if let items = shoppingListStore.shoppingLists?[shoppingListIndex!].items {
                    ForEach(items, id: \.self) { item in
                        itemCellView(item: item)
                    }
                    addNewItemElementView()
                }
            }
            createBottomButtonsView()
        }.navigationBarTitle(shoppingList.name).toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {}) {
                        Label("Teilen", systemImage: "link")
                    }
                    
                    Button(action: {}) {
                        Label("Löschen", systemImage: "trash")
                    }
                }
                label: {
                    Label("More", systemImage: "ellipsis")
                }
            }
        }
//        .navigationBarItems(trailing:
//                                Button(action: {
//                                    //share link action here?
//                                }) {
//                                    Image(systemName: "ellipsis.circle")
//                                }
//        )
    }
    private func itemCellView(item: Item) -> some View {
        HStack {
            Button(action: {shoppingListStore.toggleBoughtStateofItem(item: item, shoppingList: shoppingList)}, label: {
                if item.bought{
                    Label(
                        title: { Text(item.name + " (" + item.specification + ")").strikethrough() },
                        icon: {Image(systemName: "checkmark.circle")}
                    )
                }
                else{
                    Label(
                        title: { Text(item.name + " (" + item.specification + ")") },
                        icon: {Image(systemName: "circle")}
                    )
                }
            })
            
        }
    }
    private func addNewItemElementView() -> some View {
        HStack {
            Image(systemName: "circle.plus")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    print("onTapGesture")
                }
            TextField("Artikel eingeben", text: $newItemName,
                      onCommit: {
                        shoppingListStore.addItemToShoppingList(item: Item(name: newItemName, specification: "", icon: "", expiryDate: Date(), bought: false),shoppingList: shoppingList)
                        newItemName = ""
                      })
        }
    }
    private func createBottomButtonsView() -> some View {
        HStack {
            Button(action: { shoppingListStore.cleanUpBoughtItems(shoppingList: self.shoppingList) }) {
                Label(
                    title: { Text("Clean Up").fontWeight(.bold) },
                    icon: { Image(systemName: "trash") }
                )
            }.frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red)
            .cornerRadius(40)
            
            Button(action: {self.isAddItemModalPresented=true}) {
                Label(
                    title: { Text("Neuer Artikel").fontWeight(.bold) },
                    icon: { Image(systemName: "plus.circle.fill") }
                )
                
            }
            .sheet(isPresented: self.$isAddItemModalPresented) {
                //TODO modal doesn't appear properly
                AddItemModalView(shoppingList: shoppingList)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(40)
            
        }
        .foregroundColor(Color.white)
        .padding()
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(shoppingList: ShoppingListStore().shoppingLists![1])
    }
}

