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
    @State private var isProcessing = false
   
    @State private var contentMode: ContentMode = .fit
    @State private var selectedMockup: Mockup = MockupArray.iPhoneMockups[15]
    private let targetSize = CGSize(width: 828, height: 1792)
    private let cornerRadius: CGFloat = 200 // this is mockups corner radius
    private let baseImagePoint = CGPoint(x: 80, y: 80) // Example coordinates for overlay image
    
    var body: some View {
        VStack {
            Button {
                selectedImages = []
                finalImages = []
                
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
                    isProcessing = true
                    processImages() {result in
                        isProcessing = result
                    }
                    
                }) {
                    Text("Process Image")
                        .padding(2)
                        .background(.gray.opacity(0.5))
                }
                
                Menu {
                    ForEach (MockupArray.iPhoneMockups){item in
                        Button {
                            selectedMockup = item
                        } label: {
                            HStack {
                                Text(item.mockup.rawValue)
                                if (item.mockup.rawValue == selectedMockup.mockup.rawValue) {
                                    Image(systemName: "checkmark")
                                        .font(.callout)
                                }
                                
                            }
                        }

                    }
                    
                    ForEach (MockupArray.iPadMockups){item in
                        Button {
                            selectedMockup = item
                        } label: {
                            HStack {
                                Text(item.mockup.rawValue)
                                if (item.mockup.rawValue == selectedMockup.mockup.rawValue) {
                                    Image(systemName: "checkmark")
                                        .font(.callout)
                                }
                            }
                        }

                    }
                    
                    ForEach (MockupArray.macMockups){item in
                        Button {
                            selectedMockup = item
                        } label: {
                            HStack {
                                Text(item.mockup.rawValue)
                                if (item.mockup.rawValue == selectedMockup.mockup.rawValue) {
                                    Image(systemName: "checkmark")
                                        .font(.callout)
                                }
                            }
                        }

                    }
                    
                    ForEach (MockupArray.appleWatchMockups){item in
                        Button {
                            selectedMockup = item
                        } label: {
                            HStack {
                                Text(item.mockup.rawValue)
                                if (item.mockup.rawValue == selectedMockup.mockup.rawValue) {
                                    Image(systemName: "checkmark")
                                        .font(.callout)
                                }
                            }
                        }

                    }

                } label: {
                    HStack(spacing: 0) {
                        Text(selectedMockup.mockup.rawValue)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.callout)
                    }
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
                            .font(.callout)
                    }
                    .padding(2)
                    .background(.gray.opacity(0.5))
                    
                }


            }
            .padding()
            
            if finalImages != [] && !isProcessing{
                Button(action: {
                    saveImages()
                }) {
                    Text("Download Final Image")
                }
                .padding()
            }
            if(isProcessing) {
                HStack{
                    Text("Processing...")
                        .bold()
                        .foregroundStyle(.red)
                    
                }
                
            }
        }
        .background(Gradient(colors: [.black, .gray, .white]))
        .onChange(of: photosPickerItems) {newValue in

            Task {
                finalImages = []
                
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
    
    func processImages (completion: @escaping(Bool) -> Void) {
        
        for selectedImage in selectedImages {
            
            if let resizedImage = ImageHelper.resizeImage(image: selectedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
               let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                
                if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup) {
                    finalImages.append(finalImage)
                }
            }
        }
        completion(false)
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
