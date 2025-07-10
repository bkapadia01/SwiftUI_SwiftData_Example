//
//  RecordRow.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-02-07.
//

import SwiftUI

struct RecordRow: View {
    let record: DataItem
    
    var body: some View {
        if let imageData = record.photo, let uiImage = UIImage(data: imageData) {
            
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
        } else {
            record.defaultImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

//
//#Preview {
//    RecordRow(record: DataItem)
//}
