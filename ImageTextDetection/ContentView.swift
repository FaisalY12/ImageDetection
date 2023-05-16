//
//  ContentView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 11/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var image : Image?
    @State private var inputImage: UIImage?
    @StateObject private var textDetector = TextDetector()
   
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.image = Image(uiImage: inputImage)
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center)  {
                GeometryReader { geo in
                    VStack (spacing: geo.size.height * 0.05) {
                        SelectImageView(image: image, inputImage: $inputImage)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                            .onChange(of: inputImage) { _ in
                                loadImage()
                                self.textDetector.detectedText = ""
                            }
                        
                        ScrollTextView(detectedText: textDetector.detectedText)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                        
                        ButtonView(inputImage: $inputImage, textDetector: textDetector)
                        
                        
                    }.frame(width: geo.size.width)
                    
                }
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
