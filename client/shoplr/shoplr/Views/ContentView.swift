//
//  ContentView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

struct ContentView: View {
    //to fix dismiss modal issue
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shoppingListStore: ShoppingListStore
    
    @State private var isCreateModalPresented: Bool = false
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            if let shoppingLists = shoppingListStore.shoppingLists{
                List{
                    ForEach(shoppingLists){list in
                        NavigationLink(destination: ShoppingListView(shoppingList: list)){
                            
                            Label(
                                title: { Text(list.name) },
                                icon: { Text(list.icon) }
                            ).contextMenu {
                                Button(action: {print("Share")}) {
                                    Text("Teilen")
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            
                        }
                    }.onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                    
                    
                }.listStyle(PlainListStyle())
                .navigationBarTitle("Einkaufslisten")
                .navigationBarItems(leading: EditButton(),trailing:
                                        Button(action: {
                                            self.isCreateModalPresented.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                        }.sheet(isPresented: self.$isCreateModalPresented, onDismiss: {print("dismissed")}) {
                                            CreateListModalView()
                                        }
                )
                .environment(\.editMode, $editMode)
            }
        }
    }
    private func onDelete(offsets: IndexSet) {
        shoppingListStore.removeList(index: offsets)
    }
    
    //TODO how to handle with server side communication
    private func onMove(source: IndexSet, destination: Int) {
        shoppingListStore.shoppingLists!.move(fromOffsets: source, toOffset: destination)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShoppingListStore())
    }
}
