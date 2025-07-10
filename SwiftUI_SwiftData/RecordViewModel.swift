//
//  RecordViewModel.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-02-07.
//

import Foundation
import Vision
import SwiftUI

extension ContentView {
    
    @Observable
    class RecordViewModel: ObservableObject {
        var transformedBoundingBox: CGRect?

        var updateUI: ((String) -> Void)?
        
        func recognizeText(image: UIImage?) async -> String {
            guard let cgImage = image?.cgImage else {
                fatalError("Could not get cgImage from the provided UIImage")
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let textDetectionRequest = createTextDetectionRequest(recognitionLanguages: ["en"], image: image ?? UIImage(imageLiteralResourceName: "defaultImage"))
            
            do {
                try handler.perform([textDetectionRequest])
            } catch {
                print("Error during text recognition: \(error.localizedDescription)")
                return "Error during text recognition"
            }
            
            guard let observations = textDetectionRequest.results else {
                return "No text recognized"
            }
            
            let recognizedTextDetails = observations.map { observation -> String in
                // Extracting information from each observation
                let topCandidate = observation.topCandidates(1).first
                let text = topCandidate?.string ?? "No text"
//                let confidence = topCandidate?.confidence ?? 0.0
//                let boundingBox = observation.boundingBox
                
                // Print the information
//                print("Text: \(text) \n Confidence: \(confidence) \n BoundingBox: \(boundingBox) \n\n")
                
                return text
            }.joined(separator: ", ")
            
            DispatchQueue.main.async {
                self.updateUI?(recognizedTextDetails)
                print(recognizedTextDetails)
            }
            
            return recognizedTextDetails
        }
        

        func createTextDetectionRequest(recognitionLanguages: [String], image: UIImage) -> VNRecognizeTextRequest {
            let request = VNRecognizeTextRequest { request, error in
                var boundingBox: CGRect?

                guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                    print("Error during text recognition: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Convert UIImage to CIImage
                guard let ciImage = CIImage(image: image) else {
                    print("Error converting UIImage to CIImage")
                    return
                }
                
                // Get the input image size
                let imageSize = CGSize(width: ciImage.extent.width, height: ciImage.extent.height)
                
                // Process each recognized text observation
                for observation in observations {
                    let observationBoundingBox = observation.boundingBox
                    boundingBox = CGRect(
                        x: observationBoundingBox.origin.x * imageSize.width,
                        y: observationBoundingBox.origin.y * imageSize.height,
                        width: observationBoundingBox.size.width * imageSize.width,
                        height: observationBoundingBox.size.height * imageSize.height
                    )
                    DispatchQueue.main.async {
                        self.transformedBoundingBox = boundingBox
                    }
                          
                }
            }
            
            request.recognitionLanguages = recognitionLanguages
        request.recognitionLevel = .accurate
            return request
        }
    }
}
