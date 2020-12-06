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
        HStack{
            Image(uiImage: generateQRCode(from:listString)).resizable()
                .frame(width: 299, height: 299)
        }
    }
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
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
