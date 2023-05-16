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
    @State private var showingImagePicker = false
    @State private var failedToLoadAlert = false
    @State private var showingDetectAlert = false
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
                        SelectImageView(image: image)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                            .onTapGesture {
                                self.showingImagePicker = true
                            }
                            .onChange(of: inputImage) { _ in loadImage() }
                        
                        
                        ScrollTextView(detectedText: textDetector.detectedText)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                        
                        Button("Get Text") {
                            if self.inputImage != nil {
                                Task {
                                    await textDetector.findTextInImage(image: self.inputImage!)
                                }
                                if textDetector.state == .failed {
                                    showingDetectAlert.toggle()
                                }
                               return
                            }
                        }
                        .buttonStyle(GrowingButton())
                        
                        
                    }.frame(width: geo.size.width)
                    
                }
                
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) { ImagePicker(image: self.$inputImage, failedtoLoad: $failedToLoadAlert) }
            .alert("Oops", isPresented: $showingDetectAlert) {
            } message: {
                Text("Error occured while detecting text")
            }
            .alert("Oops", isPresented: $failedToLoadAlert) {
            } message: {
                Text("Error occured while selecting image")
            }
            
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
