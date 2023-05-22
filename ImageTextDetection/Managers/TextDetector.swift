//
//  ImageDetection.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 12/05/2023.
//

import Foundation
import Vision
import UIKit

enum VisionState {
    case idle
    case loading
    case failed
}

class TextDetector : ObservableObject {
    
    
    @Published var detectedText : String = ""
    @Published private(set) var state = VisionState.idle
    
    
    public func findTextInImage(image : UIImage) async {
        
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                self.state = .failed
            }
            return }
        
        DispatchQueue.main.async {
            self.state = .loading
            self.detectedText = ""
        }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            DispatchQueue.main.async {
                self.state = .failed
            }
            
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        DispatchQueue.main.async {
            self.detectedText = "\n " + recognizedStrings.joined(separator: " ")
            self.state = .idle
        }
        
        
        
    }
    
}
