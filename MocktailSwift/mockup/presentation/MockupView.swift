//
//  MockupView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI
import PhotosUI

struct MockupView: View {
    
    @State private var selectedMockup: Mockup = MockupArray.iPhoneMockups[15]
    @State  var selectedImages: [UIImage] = []
    @State private var selectedMockupType: MockupType = .iphone
    
        
    var body: some View {
        
        VStack {
            
            TabView(selection: $selectedMockupType,
                    content:  {
                TemplateView(mockupArray: MockupArray.iPhoneMockups, selectedMockup: MockupArray.iPhoneMockups[15], selectedImages: $selectedImages)
                    .tabItem {
                        Image(systemName: "iphone")
                        Text("iPhone")
                            
                            
                    }
                    .tag(MockupType.iphone.rawValue)
                
                TemplateView(mockupArray: MockupArray.iPadMockups, selectedMockup: MockupArray.iPadMockups[0], selectedImages: $selectedImages)
                     .tabItem {
                         
                         Image(systemName: "ipad")
                         Text("ipad")
                             
                             
                     }
                     .tag(MockupType.ipad.rawValue)
                
                TemplateView(mockupArray: MockupArray.macMockups, selectedMockup: MockupArray.macMockups[2], selectedImages: $selectedImages)
                    .tabItem {
                        Image(systemName: "macbook")
                        Text("Mac")
                            
                            
                    }
                    .tag(MockupType.mac.rawValue)
                
                TemplateView(mockupArray: MockupArray.appleWatchMockups, selectedMockup: MockupArray.appleWatchMockups[0], selectedImages: $selectedImages)
                    .tabItem {
                        Image(systemName: "applewatch")
                        Text("Watch")
                            
                            
                    }
                    .tag(MockupType.appleWatch.rawValue)
                
                
                
            })
            
        }
       
    }
    

    

}

struct TemplateView: View {
    
    
    @State  var mockupArray: [Mockup]
    @State  var selectedMockup: Mockup
    @Binding  var selectedImages: [UIImage]
    @State private var finalImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var isProcessing = false
    @State private var contentMode: ContentMode = .fit
    @State private var selectedFinalImage: UIImage = UIImage()
@State private var count = 0
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Mockview")
                    .font(.custom("Merienda-Regular", size: 20))
                    .bold()
                
                Spacer()
                
                Button(action: {
                   
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(APP_ID)?action=write-review") {
                        UIApplication.shared.open(url)
                    }


                }) {
                    Image(systemName: "star")
                       .font(.title2)
                       .foregroundStyle(.black)
                       .padding(.horizontal)

                }
                

                

                
                Image(systemName: "moon.fill")
                    .font(.title2)
                
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                Spacer()
                if isProcessing {
                    HStack {
                        Text("Processing ")
                            
                         ProgressView()
                    }
                   
                } else if finalImages == [] {
                    PhotosPicker(selection: $photosPickerItems, matching: .images) {
                        Image(selectedMockup.mockup.rawValue)
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                VStack {
                                    Text("Drag and drop your file")
                                        .bold()
                                        .foregroundStyle(.black)
                                    Text("Tap to add images")
                                        .font(.callout)
                                        .foregroundStyle(.gray)
                                }
                            }

                    }
                } else if finalImages.count == 1 {
                    
                    PhotosPicker(selection: $photosPickerItems, matching: .images) {
                        Image(uiImage: finalImages[0])
                            .resizable()
                            .scaledToFit()
                            

                    }
                    
                } else {
                    HStack {
                        Spacer()
                        ScrollView(.horizontal) {
                            ScrollViewReader {reader in
                                
                                
                                
                                HStack {
                                    ForEach(finalImages.indices, id: \.self) { index in
                                        Image(uiImage: finalImages[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.2)
                                            .onTapGesture {
                                                selectedFinalImage = finalImages[index]
                                            }
                                            .id(index) // Assign a unique ID to each image
                                    }
                                }
 
                                
                            }
                        }
                      
                        Spacer()
                    }
                        
                    PhotosPicker(selection: $photosPickerItems, matching: .images) {
                        if selectedFinalImage != UIImage() {
                            Image(uiImage: selectedFinalImage)
                                    .resizable()
                                    .scaledToFit()
                        }
                        
                        
                        
                            

                    }
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        HStack {
                            Text("Device")
                                .font(.footnote)
                                .bold()
                                .foregroundStyle(.gray)
                            Menu {
                                ForEach (mockupArray){item in
                                    Button {
                                        selectedImages = []
                                        finalImages = []
                                        selectedFinalImage = UIImage()
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
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.horizontal, 4)
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.caption2)
                                        .bold()
                                }
                                .foregroundStyle(.black)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white))
                                
                                
                            }
                        }
                        .padding(.horizontal)
    
                        Menu {
                            
                            Button("Fit") {
                                contentMode = .fit
                                finalImages = []
                                selectedFinalImage = UIImage()
                                processImages()
                            }
                            
                            Button("Fill") {
                                contentMode = .fill
                                finalImages = []
                                selectedFinalImage = UIImage()
                                processImages()
                            }
                            
                            Button("Stretch") {
                                contentMode = .stretch
                                finalImages = []
                                selectedFinalImage = UIImage()
                                processImages()
                            }
                            

                        } label: {
                            HStack(spacing: 0) {
                                Text(contentMode.rawValue)
                                    .fixedSize()
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal, 4)
                                
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                                    .bold()
                            }
                            .foregroundStyle(.black)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white))
                            
                        }
                        .padding(.horizontal)
                        
                    }
                }
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.black.opacity(0.1)))
                .padding()

                

                    
            }
            
        }
        .onAppear(perform: {
            if selectedImages != [] {
                processImages()
            }
            
        })
        .onChange(of: isProcessing){
            print("isProcessing changed: \(isProcessing)")
        }
        .onChange(of: photosPickerItems) {newValue in
           
            Task {
                
                var imagesArray : [UIImage] = []
                for item in photosPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            imagesArray.append(image)
                        }
                    }
                }
                if imagesArray != [] {
           
                    selectedImages = imagesArray
                                
                                processImages()
                }
                
                
                photosPickerItems.removeAll()
            }
        }
      
        .onChange(of: finalImages) { value in
            if finalImages.count > 1 {
                selectedFinalImage = finalImages[0]
            }
        }

    }
    
    func saveImages () {
        for image in finalImages {
            ImageHelper.saveImageToPhotosAlbum(image: image)
        }
    }
    
    func processImages() {
        isProcessing = true
        DispatchQueue.global(qos: .userInitiated).async {
            var imageArray: [UIImage] = []
            for selectedImage in selectedImages {
                if let resizedImage = ImageHelper.resizeImage(image: selectedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
                   let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                    if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup) {
                        imageArray.append(finalImage)
                    }
                }
            }
            DispatchQueue.main.async {
                finalImages = imageArray
                isProcessing = false
            }
        }
    }
}

#Preview {
    MockupView()
}
