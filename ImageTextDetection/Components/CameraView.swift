//
//  CameraView.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 22/05/2023.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    let cameraManager : CameraManager
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        
        init(_ parent: CameraView,
             didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraManager.startCamera(delegate: context.coordinator) { err in
            if let err = err {
                didFinishProcessingPhoto(.failure(err))
                return
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraManager.preview)
        cameraManager.preview.frame = viewController.view.bounds
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
}



