//
//  DataItem.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-01-01.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class DataItem: Identifiable {
    var id: String
    var textFromImage: String
    @Attribute(.externalStorage) var photo: Data?
    
    init(textFromImage: String, photo: Data?)
    {
        self.id = UUID().uuidString
        self.textFromImage = textFromImage
        self.photo = photo
    }
    
    
    func defaultImage() -> Image {
        return Image("defaultImage")
    }
}

