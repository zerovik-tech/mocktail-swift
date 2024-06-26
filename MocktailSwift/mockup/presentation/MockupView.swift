//
//  MockupView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI
import PhotosUI

struct MockupView: View {
    
    @StateObject private var paywallViewModel: PaywallViewModel
    
    @StateObject private var routingViewModel: RoutingViewModel
    
    @StateObject private var moreViewModel : MoreViewModel

    
    @State private var selectedMockup: Mockup = MockupArray.iPhoneMockups[15]
    @State  var selectedImages: [UIImage] = []
    @State private var selectedMockupType: MockupType = .iphone
    
    init(paywallViewModel: PaywallViewModel, routingViewModel: RoutingViewModel,moreViewModel : MoreViewModel) {
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        self._moreViewModel = StateObject(wrappedValue: moreViewModel)

    }
    
        
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
        .environmentObject(paywallViewModel)
        .environmentObject(routingViewModel)
       
    }

}

struct TemplateView: View {
    
    @EnvironmentObject var paywallViewModel : PaywallViewModel
    @EnvironmentObject var routingViewModel : RoutingViewModel
    
    
    @State  var mockupArray: [Mockup]
    @State  var selectedMockup: Mockup
    @Binding  var selectedImages: [UIImage]
    @State private var finalImages: [UIImage] = []
    @State private var replacedImage: UIImage = UIImage()
    @State private var isImagePickerPresented = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var replacePhotoPickerItem: PhotosPickerItem?
    @State private var isProcessing = false
    @State private var contentMode: ContentMode = .fit
    @State private var selectedFinalImageIndex: Int = 0
    @State private var showDownloadAlert = false
@State private var count = 0
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Mocktail")
                    .font(.custom("YatraOne-Regular", size: 24))
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
                

                
                Button(action: {
                   
                    selectedImages = []
                    finalImages = []
                    selectedFinalImageIndex = 0
                    

                }) {
                    Text("Clear")
                        .font(.callout)
                        .bold()

                }
                
               
                
                
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
                                            .background{ RoundedRectangle(cornerRadius: 8).fill(.blue.opacity(index == selectedFinalImageIndex ? 0.2 : 0))
                                            }
                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.2)
                                            .onTapGesture {
                                                selectedFinalImageIndex = index
                                            }
                                            .id(index) // Assign a unique ID to each image
                                    }
                                }
                                
                                
                            }
                        }
                        
                        Spacer()
                    }
                    
                    
                    
                    
                    PhotosPicker(selection: $photosPickerItems, matching: .images) {
                        if selectedFinalImageIndex < finalImages.count {
                            Image(uiImage: finalImages[selectedFinalImageIndex])
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    HStack {
                        
                        Menu {
                            
                            Button("Low Quality") {
                                if selectedFinalImageIndex < finalImages.count {
                                    ImageHelper.saveImageToPhotosAlbum(image: finalImages[selectedFinalImageIndex], quality: .low)
                                    showDownloadAlert = true
                                }
                            }
                            
                            Button("Medium Quality") {
                                if selectedFinalImageIndex < finalImages.count {
                                    ImageHelper.saveImageToPhotosAlbum(image: finalImages[selectedFinalImageIndex], quality: .medium)
                                    showDownloadAlert = true
                                }
                            }
                            
                            Button("High Quality") {
                                if selectedFinalImageIndex < finalImages.count {
                                    ImageHelper.saveImageToPhotosAlbum(image: finalImages[selectedFinalImageIndex], quality: .high)
                                    showDownloadAlert = true
                                }
                            }
                            
                            
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.footnote)
                                    .bold()
                                Text("Save")
                                    .font(.footnote)
                                    .bold()
                            }
                            .padding(4)
                            .padding(.horizontal, 2)
                            .background {
                                RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.1))
                            }

                            
                        }
                        .padding(.trailing)

                        
                        PhotosPicker(selection: $replacePhotoPickerItem) {
                            HStack {
                                Image(systemName: "repeat")
                                    .font(.footnote)
                                Text("Replace")
                                    .font(.footnote)
                            }
                            .foregroundStyle(.white)
                            .padding(4)
                            .padding(.horizontal, 2)
                            
                            .background {
                                RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.8))
                            }
                            
                        }
                        .padding(.leading)
                        
                        
                    }
                    
                    
                    
                }
                
                Spacer()
               
                HStack{
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
                                            finalImages = []
                                            selectedFinalImageIndex = 0
                                            selectedMockup = item
                                            processImages()
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
                                    processImages()
                                }
                                
                                Button("Fill") {
                                    contentMode = .fill
                                    finalImages = []
                                    processImages()
                                }
                                
                                Button("Stretch") {
                                    contentMode = .stretch
                                    finalImages = []
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
                    
                    
                    Menu {
                        
                        Button("Low Quality") {
                            saveImages(quality: .low)
                        }
                        
                        Button("Medium Quality") {
                            saveImages(quality: .medium)
                        }
                        
                        Button("High Quality") {
                            saveImages(quality: .high)
                        }
                        
                        
                    } label: {
                        Text("Download")
                            .font(.callout)
                            .foregroundStyle(.white)
                            .bold()
                            .padding(6)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
                        
                    }
                    

                }

            

                

                    
            }
            
        }
        .onAppear(perform: {
            if selectedImages != [] {
                processImages()
            }
            
        })
        .onChange(of: selectedImages, perform: { value in
            selectedFinalImageIndex = 0
        })
        .onChange(of: isProcessing){
            print("isProcessing changed: \(isProcessing)")
        }
        .onChange(of: replacePhotoPickerItem) { value in
            Task {
                
                if let replacePhotoPickerItem,
                   let data = try? await replacePhotoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data){
                        replacedImage = image
                    }
                }
                
                
            }

        }
        .onChange(of: replacedImage) { value in
            if replacedImage != UIImage() {
                isProcessing = true
                DispatchQueue.global(qos: .userInitiated).async {
                    var image: UIImage = UIImage()
                   
                        if let resizedImage = ImageHelper.resizeImage(image: replacedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
                           let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                            if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup, addWatermark: true) {
                                image = finalImage
                            }
                        }
                    
                    DispatchQueue.main.async {
                    
                        finalImages.remove(at: selectedFinalImageIndex)
                        finalImages.insert(image, at: selectedFinalImageIndex)
                        isProcessing = false
                        
                    }
                }
            }
            

            
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
        .alert("Mockup Saved Successfully" , isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
      
        

    }
    
    func saveImages (quality: Quality) {
        for image in finalImages {
            ImageHelper.saveImageToPhotosAlbum(image: image, quality: quality)
        }
        showDownloadAlert = true
    }
    
    func processImages() {
        isProcessing = true
        DispatchQueue.global(qos: .userInitiated).async {
            var imageArray: [UIImage] = []
            for selectedImage in selectedImages {
                if let resizedImage = ImageHelper.resizeImage(image: selectedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
                   let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                    if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup, addWatermark: true) {
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

//#Preview {
//    MockupView()
//}
