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
    
    @Environment(\.modelContext) private var context
    @State private var selectedPhoto: PhotosPickerItem?
    //    @StateObject private var viewModel = TextRecognitionViewModel()
    @StateObject private var recordViewModel = RecordViewModel()
    
    // retrive all instances of dataItem from data store into an array
    @Query private var items: [DataItem]
    @State var item: DataItem?
    
    @State private var label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var body: some View {
        
        NavigationStack {
            VStack{
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared())
                {
                    Label("Select a photo", systemImage: "camera")
                }
                .onChange(of: selectedPhoto) {
                    Task {
                        await addItem()
                        selectedPhoto = nil
                    }
                }
            }
            List {
                ForEach (items) { item in
                    NavigationLink(value: item) {
                        RecordRow(record: item)
                    }
                }
                .onDelete(perform: { indexes in
                    for index in indexes {
                        deleteItem(items[index])
                    }
                })
            }
            .navigationDestination(for: DataItem.self) {item in
                RecordDetailView(selectedItem: item)
            }
        }
    }
    
    func deleteItem(_ item: DataItem) {
        context.delete(item)
    }
    
    func loadPhoto() {
        Task { @MainActor in
            self.item?.photo = try await
            selectedPhoto?.loadTransferable(type: Data.self)
        }
    }
    
    func addItem() async {
        if let selectedItemImage = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            let image = UIImage(data: selectedItemImage)
            let recognizedText = await recordViewModel.recognizeText(image: image)
            let newItem = DataItem(textFromImage: recognizedText, photo: selectedItemImage)
            context.insert(newItem)
        }
    }
}
//
//#Preview {
//    ContentView()
//}


