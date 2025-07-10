//
//  TextRecognitionViewModel.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-02-06.
//

import Foundation
import SwiftUI
import Vision

extension ContentView {
    
    @Observable
    class TextRecognitionViewModel: ObservableObject {
//        @Published var inputImage: UIImage = UIImage(named: "your_image_name") ?? UIImage()
//        @Published var recognizedTextObservations: [VNRecognizedTextObservation] = []

        func performTextRecognition() {
            // Implement your text recognition logic here
            // Update recognizedTextObservations based on the results
        }
    }

    struct BoundingBoxView: View {
        let image: UIImage
        let observations: [VNRecognizedTextObservation]

        var body: some View {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    GeometryReader { geometry in
                        self.overlay(for: geometry.size)
                    }
                )
        }

        private func overlay(for size: CGSize) -> some View {
            let imageSize = image.size

            return ZStack {
                ForEach(observations, id: \.self) { observation in
                    let boundingBox = observation.boundingBox
                    let scaledBoundingBox = CGRect(
                        x: boundingBox.origin.x * imageSize.width,
                        y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                        width: boundingBox.width * imageSize.width,
                        height: boundingBox.height * imageSize.height
                    )

                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: scaledBoundingBox.width, height: scaledBoundingBox.height)
                        .position(
                            x: scaledBoundingBox.origin.x + scaledBoundingBox.width / 2,
                            y: scaledBoundingBox.origin.y + scaledBoundingBox.height / 2
                        )
                }
            }
        }
    }
    
    
}

