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
    var name: String
    @Attribute(.externalStorage) var photo: Data?
    
    init(name: String, photo: Data?)
    {
        self.id = UUID().uuidString
        self.name = name
        self.photo = photo
    }
    
    
    func defaultImage() -> Image {
        return Image("defaultImage")
    }
}

