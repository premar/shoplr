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
    //@StateObject var listLoader = ShoppingListStore()
    @State private var show_modal: Bool = false
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
                            )
                            
                        }
                    }.onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                    
                    
                }.listStyle(PlainListStyle())
                .navigationBarTitle("Einkaufslisten")
                .navigationBarItems(leading: EditButton(),trailing:
                                        Button(action: {
                                            self.show_modal.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                        }.sheet(isPresented: self.$show_modal, onDismiss: {print("dismissed")}) {
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
    
    private func onMove(source: IndexSet, destination: Int) {
        shoppingListStore.shoppingLists!.move(fromOffsets: source, toOffset: destination)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
