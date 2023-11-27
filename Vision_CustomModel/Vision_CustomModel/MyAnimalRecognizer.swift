//
//  MyAnimalRecognizer.swift
//  Vision_CustomModel
//
//  Created by Manish on 22/11/23.
//

import Foundation
import Vision
import UIKit


class MyAnimalRecognizer {
    
    func loadModel() -> VNCoreMLModel {
        let defaultConfig = MLModelConfiguration()
        
        // Name of the model
        guard let recognizer = try? MyAnimalRecogniser_Model(configuration: defaultConfig) else {
            fatalError("Could not init model")
        }
        
        let model = recognizer.model
        
        guard let coreMLModel = try? VNCoreMLModel(for: model) else {
            fatalError("Could not load the model")
        }
        
        return coreMLModel
    }
    
    func recognizeAnimal(in image: UIImage, onResult: @escaping (String) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let request = VNCoreMLRequest(model: self.loadModel())
            request.imageCropAndScaleOption = .centerCrop
            
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: image.cgOrientation)
            
            // Use device for accurate results
            // also, will crash on simulator
            try! handler.perform([request])
            
            let observations = request.results as? [VNClassificationObservation]
            let mappedResult = observations?.map {
                "\($0.identifier) : \($0.confidence.percentage)"
            } ?? []
            onResult(mappedResult.joined(separator: "\n"))
            // confidence outside the range of [0,1] is meaning less
        }
        
    }
    
}

extension VNConfidence {
    
    var percentage: String {
        if self > 1 || self < 0 { return "0%" }
        
        let resulted = self * 100
        let formatted = String(format: "%.2f", resulted)
        return formatted + "%"
    }
    
}

extension UIImage {
    
    var cgOrientation: CGImagePropertyOrientation {
        switch self.imageOrientation {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        case .upMirrored:
            return .upMirrored
        case .downMirrored:
            return .downMirrored
        case .leftMirrored:
            return .leftMirrored
        case .rightMirrored:
            return .rightMirrored
        @unknown default:
            return .up
        }
    }
    
}
