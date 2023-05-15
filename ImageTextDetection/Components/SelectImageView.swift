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
            Rectangle()
                .fill(Color.secondary)
            
            image?
                .resizable()
                .scaledToFill()
            
            Text("Tap to select a picture")
                .foregroundColor(.white)
                .font(.headline)
            
        }
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView()
    }
}
