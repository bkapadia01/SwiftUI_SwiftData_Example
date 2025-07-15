//
//  RecordDetailView.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-02-07.
//

import SwiftUI

extension ContentView {
    struct RecordDetailView: View {
        
        @StateObject private var recordViewModel = RecordViewModel()
        @State private var boundingBox: CGRect?
        let selectedItem: DataItem
        
        var body: some View {
            VStack {
                if let imageData = selectedItem.photo, let uiImage = UIImage(data: imageData) {
                    //                Image(uiImage: uiImage)
                    //
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .overlay(alignment: .center) {
                            Rectangle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width: recordViewModel.transformedBoundingBox?.width, height: recordViewModel.transformedBoundingBox?.height)
//                                .position(x: recordViewModel.transformedBoundingBox?.midX, y: recordViewModel.transformedBoundingBox?.midY)
                        }
                    
                }
                
                
                
                
                
                Text(selectedItem.textFromImage).padding(3).border(.blue)
                Spacer()
                
            }
            
        }
    }
}

//#Preview {
//    RecordDetailView()
//}
