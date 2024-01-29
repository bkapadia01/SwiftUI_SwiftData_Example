//
//  ContentView.swift
//  SwiftUI_SwiftData
//
//  Created by Bhavin Kapadia on 2024-01-01.
//

import SwiftUI
import SwiftData
import PhotosUI
import Vision

struct ContentView: View {
    
    // path to the context for working with data
    // Data context is the layer between peristent store and object in memory -> faciliate storing objects into persistent store and reverse: from persistnet store to memory
    @Environment(\.modelContext) private var context
    @State private var selectedItem: PhotosPickerItem?
    
    // retrive all instances of dataItem from data store into an array
    @Query private var items: [DataItem]
    private var item: DataItem?
    
    private let label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var body: some View {
        VStack {
            Section{
                PhotosPicker(selection: $selectedItem, matching: .images)
                {
                    Label("Select a photo", systemImage: "camera")
                    
                }
                .onChange(of: selectedItem) {
                    // Call the method when the selected item changes (image is picked)
                    Task {
                        await addItem()
                    }
                }
                
                List {
                    ForEach (items) { item in
                        VStack {

                            if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 200, height: 200)
                                    .overlay(
                                       RoundedRectangle(cornerRadius: 10) // Adjust the corner radius as needed
                                           .stroke(Color.black, lineWidth: 2) // Adjust the color and line width as needed
                                   )
                            } else {
                                // Use the default image if there is no associated photo
                                item.defaultImage()
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 200, height: 200)
                            }
                            Text(item.name)
                        }
                        .listRowSeparatorTint(.blue)
                    }
                    .onDelete(perform: { indexes in
                        for index in indexes {
                            deleteItem(items[index])
                        }
                    })
                }
            }
        }
    }
        
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }

    func loadPhoto() {
        Task { @MainActor in
            self.item?.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }

    func addItem() async {
        if let selectedItemImage = try? await selectedItem?.loadTransferable(type: Data.self) {
            let image = UIImage(data: selectedItemImage)
            await recognizeText(image: image)
            let newItem = await DataItem(name: self.label.text ?? "error?", photo: selectedItemImage)
            context.insert(newItem)
        }
    }
    
    
    private func recognizeText(image: UIImage?) async {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get cgImage")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observeations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let text = observeations.compactMap ({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            

            
            DispatchQueue.main.async {
                label.text = text
            }
        }
        
        request.recognitionLanguages = ["en"]
        request.recognitionLevel = .accurate
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}
