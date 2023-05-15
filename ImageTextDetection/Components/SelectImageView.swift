//
//  SelectImageView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 15/05/2023.
//

import SwiftUI

struct SelectImageView: View {
    
    var image : Image?
    
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
            
        }   .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(style: .init(lineWidth: 5))
        )
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView()
    }
}
