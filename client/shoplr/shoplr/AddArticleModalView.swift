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
    
    var body: some View {
        VStack {

                    Button(action: {
                        print("dismisses form")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Dismiss")
                    }.padding(.bottom, 50)
                    Text("This is the add article modal")
                }
    }
}
struct AddArticleModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddArticleModalView()
    }
}
