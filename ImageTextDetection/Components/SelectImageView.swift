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
    @State private var failedToLoadAlert = false
    @State private var showingImagePicker = false
    
    
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
            self.showingImagePicker = true
        }
        
        .alert("Oops", isPresented: $failedToLoadAlert) {
        } message: {
            Text("Error occured while selecting image")
        }
        .sheet(isPresented: $showingImagePicker) { ImagePicker(image: self.$inputImage, failedtoLoad: $failedToLoadAlert) }
    }
}


