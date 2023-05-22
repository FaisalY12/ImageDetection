//
//  SelectImageView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 15/05/2023.
//

import SwiftUI

struct SelectImageView: View {
    
    var image : Image?
    @Binding var inputImage : UIImage?
    @State var selectCamera : Bool = false
    @State private var failedToLoadAlert = false
    @State private var showingImagePicker = false
    @State var showCustomCameraView : Bool = false
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.secondary)
            
            image?
                .resizable()
                .cornerRadius(14)
            
            
            Text("Tap to select a picture")
                .foregroundColor(.white)
                .font(.headline)
                .opacity(self.inputImage != nil ? 0.5 : 1)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(style: .init(lineWidth: 3))
        )
        .onTapGesture {
            selectCamera.toggle()
        }
        
        
        .alert("Select Picture Source", isPresented:$selectCamera) {
            Button("Library", action: { self.showingImagePicker.toggle()})
            Button("Camera", action: {self.showCustomCameraView.toggle()})
            Button("Cancel", role: .cancel, action: {})
        }
        .alert("Oops", isPresented: $failedToLoadAlert) {
        } message: {
            Text("Error occured while selecting image")
        }
        .sheet(isPresented: $showingImagePicker) { ImagePicker(image: self.$inputImage, failedtoLoad: $failedToLoadAlert) }
        .sheet(isPresented: $showCustomCameraView, content: {
            CustomCameraView(capturedImage: $inputImage)
        })
    }
}


