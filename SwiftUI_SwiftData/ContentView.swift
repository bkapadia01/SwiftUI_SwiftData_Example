//
//  ContentView.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-01-01.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // path to the context for working with data
    // Data context is the layer between peristent store and object in memory -> faciliate storing objects into persistent store and reverse: from persistnet store to memory
    @Environment(\.modelContext) private var context
    
    // retrive all instances of dataItem from data store into an array
    @Query private var items: [DataItem]
    var body: some View {
        VStack {
            
            Text("Tap on this button to add Data!")
            Button("Add an item") {
                addItem()
            }
            
            List {
                ForEach (items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button {
                            updateItem(item)
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }

                        
                    }
                }
                .onDelete(perform: { indexes in
                    for index in indexes {
                        deleteItem(items[index])
                    }
                })
            }
        }
        .padding()
    }
    
    func addItem() {
        // Create the item
        let item = DataItem(name: "Test item")
        
        // add item to data context
        context.insert(item)
    }
    
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }
    
    func updateItem(_ item: DataItem) {
        // edit item data
        item.name = "Update text item"
        
        // save the context
        try? context.save()
    }
}

#Preview {
    ContentView()
}
