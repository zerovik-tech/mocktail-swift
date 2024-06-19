//
//  ContentView.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var finalImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var didStartProcessing = false
    @State private var didFinishProcessing = false
    @State private var contentMode: ContentMode = .fit
    
    private let targetSize = CGSize(width: 1180, height: 2556)
    private let cornerRadius: CGFloat = 300 // this is mockups corner radius
    private let baseImagePoint = CGPoint(x: 80, y: 80) // Example coordinates for overlay image
    
    var body: some View {
        VStack {
            Button {
                selectedImages = []
                finalImages = []
                didStartProcessing = false
                didFinishProcessing = false
            } label: {
                Text("Clear")
                
            }
            .padding()
            
            PhotosPicker(selection: $photosPickerItems, matching: .images) {
                Image(systemName: "camera.fill")
                    .font(.title)

            }

            
            HStack{
                ScrollView {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                            .padding()
                    }
                }
                
                ScrollView {
                    ForEach(finalImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                            .padding()
                        
                    }
                }
            }
            
            //            if let selectedImage = selectedImage {
            //                Image(uiImage: selectedImage)
            //                    .resizable()
            //                    .scaledToFit()
            //                    .frame(width: 200, height: 200)
            //                    .padding()
            //            } else {
            //                Image(systemName: "camera.fill")
            //                    .font(.title)
            //                    .onTapGesture {
            //                        isImagePickerPresented.toggle()
            //                    }
            //                    .padding()
            //            }
            //
            //            if let finalImage = finalImage {
            //                Image(uiImage: finalImage)
            //                    .resizable()
            //                    .scaledToFit()
            //                    .frame(width: 200, height: 200)
            //                    .padding()
            //            }
            HStack {
                Button(action: {
                    
                   processImages()
                }) {
                    Text("Process Image")
                        .padding(2)
                        .background(.gray.opacity(0.5))
                }
                
                Menu {
                    Button("Fit") {
                        contentMode = .fit
                    }
                    
                    Button("Fill") {
                        contentMode = .fill
                    }
                    
                    Button("Stretch") {
                        contentMode = .stretch
                    }
                    

                } label: {
                    HStack(spacing: 0) {
                        Text(contentMode.rawValue)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.title3)
                    }
                    .padding(2)
                    .background(.gray.opacity(0.5))
                    
                }


            }
            .padding()
            
            if finalImages != nil && didFinishProcessing == true {
                Button(action: {
                    saveImages()
                }) {
                    Text("Download Final Image")
                }
                .padding()
            } else if(didStartProcessing && didFinishProcessing == false) {
                Text("Processing...")
                    .font(.title3)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onChange(of: photosPickerItems) {newValue in

            Task {
                finalImages = []
                didStartProcessing = false
                didFinishProcessing = false
                for item in photosPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImages.append(image)
                        }
                    }
                }
                
                photosPickerItems.removeAll()
            }
        }
        //        .sheet(isPresented: $isImagePickerPresented) {
        //            ImagePicker(selectedImage: $selectedImage)
        //        }
    }
    
    func saveImages () {
        for image in finalImages {
            ImageHelper.saveImageToPhotosAlbum(image: image)
        }
    }
    
    func processImages () {
        for selectedImage in selectedImages {
            if let resizedImage = ImageHelper.resizeImage(image: selectedImage, targetSize: targetSize, contentMode: contentMode),
               let overlayImage = UIImage(named: "mockup14Pro") {
                
                if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, cornerRadius: cornerRadius) {
                    finalImages.append(finalImage)
                }
            }
        }
        didFinishProcessing = true
        
    }
    
}

//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        var configuration = PHPickerConfiguration(photoLibrary: .shared())
//        configuration.filter = .images
//        configuration.selectionLimit = 1
//
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true)
//            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
//                return
//            }
//            provider.loadObject(ofClass: UIImage.self) { image, error in
//                DispatchQueue.main.async {
//                    self.parent.selectedImage = image as? UIImage
//                }
//            }
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
