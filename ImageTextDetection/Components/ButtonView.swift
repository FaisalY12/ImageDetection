//
//  TranslateButtonView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 15/05/2023.
//

import SwiftUI



struct ButtonView: View {
    @Binding public var inputImage: UIImage?;
    @State private var showingDetectAlert = false
    @ObservedObject var textDetector : TextDetector
    @ObservedObject var objectDetector : ObjectDetector
    
    var body: some View {
        HStack{
            Button {
                if self.inputImage != nil {
                    objectDetector.detectedText = ""
                    Task .detached {
                        await textDetector.findTextInImage(image: self.inputImage!)
                    }
                    if textDetector.state == .failed {
                        showingDetectAlert.toggle()
                    }
                    return
                }
                
            } label : {
                
                switch textDetector.state {
                    
                case .loading:
                    ProgressView()
                        .progressViewStyle(LoadingProgess())
                default :
                    Text("Get Text")
                }
                
            }.buttonStyle(GrowingButton())
            
            Button {
                if self.inputImage != nil {
                    textDetector.detectedText = ""
                    Task .detached {
                        await self.objectDetector.findObjectInImage(image: self.inputImage!)
                    }
                }
            } label : {
                
                switch objectDetector.state {
                    
                case .loading:
                    ProgressView()
                        .progressViewStyle(LoadingProgess())
                default :
                    Text("Get Object")
                }
                
            }.buttonStyle(GrowingButton())
            
        }.disabled(textDetector.state == .loading ? true : false)
            .opacity(textDetector.state == .loading ? 0.7 : 1)
            .alert("Oops", isPresented: $showingDetectAlert) {
            } message: {
                Text("Error occured while detecting text")
            }
    }
}


struct LoadingProgess : ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(.white)
        .onAppear() {}}
    
    
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.05), value: configuration.isPressed)
    }
}
