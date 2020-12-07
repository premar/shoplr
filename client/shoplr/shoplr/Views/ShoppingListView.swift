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
    
    @ObservedObject var shoppingList: ShoppingList
    
    @State var activeSheet: ActiveSheet?
    
    @State private var newItemName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if let items = shoppingList.items {
                    ForEach(items, id: \.self) { item in
                        ItemRowView(item: item,shoppingList: shoppingList)
                    }
                    addNewItemElementView()
                }
            }.sheet(item: $activeSheet,onDismiss: {activeSheet = nil}) { item in
                switch item {
                case .addItemModal:
                    AddItemModalView(shoppingList: shoppingList)
                case .shareModal:
                    ShareModalView(listString: "shoplr://" + shoppingList.id.uuidString)
                }
            }
            createBottomButtonsView()
        }
        .navigationBarTitle(shoppingList.name).toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {
                        activeSheet = .shareModal
                    }) {
                        Label("Teilen", systemImage: "link")
                    }
                }
                label: {
                    Label("More", systemImage: "ellipsis").imageScale(.large).frame(width: 70, height: 70, alignment: .trailing)
                }
            }
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
                        shoppingListStore.addItemToShoppingList(item: Item(name: newItemName, specification: "", icon: "", expiryDate: nil, bought: false),shoppingList: self.shoppingList)
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
            
            Button(action: {activeSheet = .addItemModal}) {
                Label(
                    title: { Text("Neuer Artikel").fontWeight(.bold) },
                    icon: { Image(systemName: "plus.circle.fill") }
                )
                
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
struct ItemRowView: View{
    
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    @ObservedObject var item: Item
    @State private var showDateAlert = false
    
    let shoppingList: ShoppingList
    
    var body: some View {
        HStack{
            Button(action: {shoppingListStore.toggleBoughtStateofItem(item: item, shoppingList: shoppingList)}, label: {
                
                if item.bought{
                    Label(
                        title: { Text(item.name + (item.specification.isEmpty ?  "":"("+item.specification + ")")).strikethrough() },
                        icon: {Image(systemName: "checkmark.circle")}
                    )
                }
                else{
                    Label(
                        title: { Text(item.name + (item.specification.isEmpty ?  "":"("+item.specification + ")")) },
                        icon: {Image(systemName: "circle")}
                    )
                    
                    
                }
                
            })
            Spacer()
            if(item.expiryDate != nil){
                
                Image(systemName:"clock")
                    .onTapGesture {
                        showDateAlert = true
                    }.alert(isPresented: $showDateAlert, content: {
                        Alert(title: Text("Diesen Artikel brauche ich bis"), message: Text(item.expiryDate!,style: .date), dismissButton: .default(Text("Ok")))
                    }).imageScale(.large).frame(width: 70, alignment: .trailing)
            }
            
        }
    }
    
}
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(shoppingList: ShoppingList( name: "Einkaufslsite", icon: "😃", items: [Item(name: "Artikel 1", specification: "1 ", icon: "", expiryDate: Date(), bought: false),Item(name: "Artikel 2", specification: "1", icon: "", expiryDate: nil, bought: false)]))
    }
}

enum ActiveSheet: Identifiable {
    case addItemModal, shareModal
    
    var id: Int {
        hashValue
    }
}
