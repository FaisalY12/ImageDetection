//
//  CameraManager.swift
//  ImageTextDetection
//
//  Created by Younis, Faisal (F.) on 22/05/2023.
//

import Foundation
import AVFoundation

class CameraManager: ObjectDetector {
    
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    var output = AVCapturePhotoOutput()
    let preview = AVCaptureVideoPreviewLayer()
    
    
    func startCamera(delegate: AVCapturePhotoCaptureDelegate, completion : @escaping (Error?) -> () ) {
        self.delegate = delegate
    }
    
    private func hasPermission(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                preview.videoGravity = .resizeAspectFill
                preview.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func takePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
}
