//
//  TranslatedTextView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 15/05/2023.
//

import SwiftUI

struct ScrollTextView: View {
    public var detectedText: String;
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .stroke(style: .init(lineWidth: 5))
            ScrollView(){
                Text("\(detectedText)")
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        
       
    }
}

struct ScrollTextView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTextView(detectedText: "asd")
    }
}
