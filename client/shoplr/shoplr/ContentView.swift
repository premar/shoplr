//
//  ContentView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var listLoader = ListLoader()
    @State private var show_modal: Bool = false
    @State private var editMode = EditMode.inactive
    var body: some View {
        NavigationView {
            if let shoppingLists = listLoader.shoppingLists{
                List{
                    ForEach(shoppingLists){list in
                        
                        NavigationLink(destination: ShoppingListView(shoppinglist: list)){
                            
                            Label(
                                title: { Text(list.name) },
                                icon: { Image(systemName: list.icon) }
                            )
                        }
                    }.onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                    
                    
                }.listStyle(PlainListStyle())
                .navigationBarTitle("Einkaufslisten")
                .navigationBarItems(leading: EditButton(),trailing:
                                        Button(action: {
                                            self.show_modal = true
                                        }) {
                                            Image(systemName: "plus")
                                        }.sheet(isPresented: self.$show_modal) {
                                            CreateListModalView()
                                        }
                )
                .environment(\.editMode, $editMode)
                
            }
        }
    }
    private func onDelete(offsets: IndexSet) {
        //Implement Logic to delete List
        if var list = listLoader.shoppingLists{
            list.remove(atOffsets: offsets)
            listLoader.shoppingLists=list
        }
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        if var list = listLoader.shoppingLists{
            list.move(fromOffsets: source, toOffset: destination)
            listLoader.shoppingLists=list
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
