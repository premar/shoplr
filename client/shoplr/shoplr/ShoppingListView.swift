//
//  ShoppingListView.swift
//  shoplr
//
//  Created by Oliver on 16.11.20.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var shoppingListStore: ShoppingListStore

    @State var shoppingList: ShoppingList
    @State private var show_modal: Bool = false

    @State private var newArticleName: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            List {
                if let articles = shoppingList.articles {
                    ForEach(articles) { article in
                        HStack {
                            Image(systemName: "circle")
                            Text(article.name + " (" + article.specification + ")")
                        }
                    }
                    addNewTaskElement()
                }
            }
            bottomButton()
        }.navigationBarTitle(shoppingList.name)
                .navigationBarItems(trailing:
                Button(action: {
                    print("Button Pushed")
                    self.show_modal = true
                }) {
                    Image(systemName: "ellipsis.circle")
                }.sheet(isPresented: self.$show_modal) {
                    AddArticleModalView(shoppingList: shoppingList)
                }
                )
    }
    private func addNewTaskElement() -> some View {
        HStack {
            Image(systemName: "circle.plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        print("onTapGesture")
                    }
            TextField("Artikel eingeben", text: $newArticleName,
                    onCommit: {
                        shoppingListStore.addArticleToShoppingList(article: Article(name: newArticleName, specification: "Rober C Martin", icon: "", expiryDate: Date(), bought: false),shoppingList: shoppingList)
                        newArticleName = ""
                    })
        }
    }
    private func bottomButton() -> some View {
        HStack {
            Button(action: { print("print") }) {
                Label(
                        title: { Text("Clean Up").fontWeight(.bold) },
                        icon: { Image(systemName: "trash") }
                )
            }.frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red)
            .cornerRadius(40)

            Button(action: { print("print")}) {
                Label(
                        title: { Text("New Task").fontWeight(.bold) },
                        icon: { Image(systemName: "plus.circle.fill") }
                )

            }.frame(height: 50)
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

