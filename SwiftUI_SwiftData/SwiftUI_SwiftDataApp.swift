//
//  SwiftUI_SwiftDataApp.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-01-01.
//

import SwiftUI
import SwiftData

@main
struct SwiftUI_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DataItem.self) // create a container with dataitem type that i wannt to pass in
    }
}

