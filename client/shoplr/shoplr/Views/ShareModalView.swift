//
//  ShareModalView.swift
//  shoplr
//
//  Created by Oliver on 06.12.20.
//

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins

struct ShareModalView: View {
    @Environment(\.presentationMode) var presentationMode
        
    var listString : String

    var body: some View {
        VStack{
            Text("Zeige einfach diesen QR Code").font(.title).multilineTextAlignment(.center)
            Image(uiImage: generateQRCode(from:listString)).resizable().scaledToFit()
                .frame(width: 299, height: 299)
            Text("oder teile diesen Link:")
            HStack{
            Button(listString, action:{
                UIPasteboard.general.string = listString
            }).font(.footnote)
                Image(systemName: "doc.on.clipboard").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = outputImage.transformed(by: transform)
            if let cgimg = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) {
                
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

}
struct ShareModalView_Previews: PreviewProvider {
    static var previews: some View {
        ShareModalView(listString: "blabla")
    }
}
