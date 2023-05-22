//
//  ObjectDetector.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 16/05/2023.
//

import Foundation
import Vision
import UIKit
import CoreML

class ObjectDetector : ObservableObject {
    
    @Published var detectedText : String = ""
    @Published var state : VisionState = .idle
    
    static func createImageClassifier() -> VNCoreMLModel {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()
        
        // Create an instance of the image classifier's wrapper class.
        // Get the underlying model instance.
        
        guard let imageClassifierModel = try? MobileNetV2(configuration: defaultConfig).model else {
            fatalError("App failed to create an image classifier model instance.")
        }
        
        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }
        
        return imageClassifierVisionModel
    }
    
    
    private static let imageClassifier = createImageClassifier()
    
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        // Create an image classification request with an image classifier model.
        
        let imageClassificationRequest = VNCoreMLRequest(model: ObjectDetector.imageClassifier,
                                                         completionHandler: visionRequestHandler)
        return imageClassificationRequest
    }
    
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        
        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }
        
        if request.results == nil {
            print("Vision request had no results.")
            return
        }
        
        guard let observations = request.results as? [VNClassificationObservation],
              let firstObservation = observations.first  else {
            
            print("VNRequest could not get result")
            return
        }
        
        let confidence = CGFloat(firstObservation.confidence) * 100
        let confidenceString =  String(format: "%.2f", confidence)
        
        DispatchQueue.main.async {
            self.state = .idle
            self.detectedText = "\n Identified as: " + firstObservation.identifier + " \n " + "Object Confidence: " + confidenceString
        
        }
        print(firstObservation.identifier)
    }
    
    func findObjectInImage(image: UIImage) {
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.main.async {
            self.state = .loading
        
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = createImageClassificationRequest()
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        
    }
}
