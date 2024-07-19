//
//  MockupView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI
import PhotosUI
import PostHog

struct MockupView: View {
    
    @StateObject private var paywallViewModel: PaywallViewModel
    
    @StateObject private var routingViewModel: RoutingViewModel
    
    @StateObject private var moreViewModel : MoreViewModel
    
    
    @State private var selectedMockup: Mockup = MockupArray.iPhoneMockups[15]
    @State  var selectedImages: [UIImage] = []
    @State private var finalImages: [UIImage] = []
    @State private var selectedFinalImageIndex: Int = 0
    @State private var selectedMockupType: MockupType = .iphone
    @State var selectedTab: Tab = .iphone
  
    
    
    
    init(paywallViewModel: PaywallViewModel, routingViewModel: RoutingViewModel,moreViewModel : MoreViewModel) {
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        self._moreViewModel = StateObject(wrappedValue: moreViewModel)
        
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Text("Mocktail")
                        .font(.custom("YatraOne-Regular", size: 24))
                        .bold()
                    
                    Spacer()
                    
                 
                    
                    Button(action: {
                        PostHogSDK.shared.capture(PostHogEvents.mockup_star.rawValue)
                        
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
                        PostHogSDK.shared.capture(PostHogEvents.mockup_clear.rawValue)
                        
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
                
                HStack {
                    CustomTabBar(selectedTab: $selectedTab)
                        .padding(.horizontal, 4)
                    
                    
                }
                
                
                switch selectedTab {
                case .iphone:
                    TemplateView(selectedMockupType: .iphone, mockupArray: MockupArray.iPhoneMockups, selectedMockup: MockupArray.iPhoneMockups[15], selectedImages: $selectedImages, selectedFinalImageIndex: $selectedFinalImageIndex, finalImages: $finalImages)
                    
                case .ipad:
                    TemplateView(selectedMockupType: .ipad, mockupArray: MockupArray.iPadMockups, selectedMockup: MockupArray.iPadMockups[0], selectedImages: $selectedImages, selectedFinalImageIndex: $selectedFinalImageIndex, finalImages: $finalImages)
                    
                case .macbook:
                    TemplateView(selectedMockupType: .mac,mockupArray: MockupArray.macMockups, selectedMockup: MockupArray.macMockups[2], selectedImages: $selectedImages, selectedFinalImageIndex: $selectedFinalImageIndex, finalImages: $finalImages)
                    
                case .applewatch:
                    TemplateView(selectedMockupType: .appleWatch,mockupArray: MockupArray.appleWatchMockups, selectedMockup: MockupArray.appleWatchMockups[0], selectedImages: $selectedImages, selectedFinalImageIndex: $selectedFinalImageIndex, finalImages: $finalImages)
                    
                }
                
                
                //            TabView(selection: $selectedMockupType,
                //                    content:  {
                //                TemplateView(selectedMockupType: selectedMockupType, mockupArray: MockupArray.iPhoneMockups, selectedMockup: MockupArray.iPhoneMockups[15], selectedImages: $selectedImages)
                //                    .tabItem {
                //                        Image(systemName: "iphone")
                //                        Text("iPhone")
                //                            
                //                            
                //                    }
                //                    .tag(MockupType.iphone.rawValue)
                //                
                //                TemplateView(selectedMockupType: selectedMockupType, mockupArray: MockupArray.iPadMockups, selectedMockup: MockupArray.iPadMockups[0], selectedImages: $selectedImages)
                //                     .tabItem {
                //                         
                //                         Image(systemName: "ipad")
                //                         Text("iPad")
                //                             
                //                             
                //                     }
                //                     .tag(MockupType.ipad.rawValue)
                //                
                //                TemplateView(selectedMockupType: selectedMockupType,mockupArray: MockupArray.macMockups, selectedMockup: MockupArray.macMockups[2], selectedImages: $selectedImages)
                //                    .tabItem {
                //                        Image(systemName: "macbook")
                //                        Text("Mac")
                //                            
                //                            
                //                    }
                //                    .tag(MockupType.mac.rawValue)
                //                
                //                TemplateView(selectedMockupType: selectedMockupType,mockupArray: MockupArray.appleWatchMockups, selectedMockup: MockupArray.appleWatchMockups[0], selectedImages: $selectedImages)
                //                    .tabItem {
                //                        Image(systemName: "applewatch")
                //                        Text("Watch")
                //                            
                //                            
                //                    }
                //                    .tag(MockupType.appleWatch.rawValue)
                //                
                //                
                //                
                //            })
                
                
            }
            .environmentObject(paywallViewModel)
            .environmentObject(routingViewModel)
            .environmentObject(moreViewModel)
            .onAppear {
                let structName = String(describing: type(of: self))
                PostHogSDK.shared.capture(structName)
            }
        }
    }
    
}

enum SaveOption {
    case download
    case save
    case saveWithBackground
}

struct TemplateView: View {
    
    @EnvironmentObject var paywallViewModel : PaywallViewModel
    @EnvironmentObject var routingViewModel : RoutingViewModel
    @EnvironmentObject var moreViewModel : MoreViewModel
    
    
    @State var selectedMockupType : MockupType
    @State  var mockupArray: [Mockup]
    @State  var selectedMockup: Mockup
    @Binding  var selectedImages: [UIImage]
    @Binding  var selectedFinalImageIndex: Int
    @Binding  var finalImages: [UIImage]
    
    @State private var replacedImage: UIImage = UIImage()
    @State private var isImagePickerPresented = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State private var replacePhotoPickerItem: PhotosPickerItem?
    @State private var isProcessing = false
    @State private var contentMode: ContentMode = .fit
    @State private var showDownloadAlert = false
    @State private var count = 0
    @State private var showUpgradeAlert : Bool = false
    @State private var showAccessDeniedAlert : Bool = false
    
    
    
    
    
  
    
    var body: some View {
        
        
        VStack {
            VStack {
                
            }
            .alert(isPresented: $showAccessDeniedAlert, content: {
                Alert(
                    title: Text("Access Denied"),
                    message: Text("Please allow access to the photo library in Settings."),
                    primaryButton: .cancel() {
                        PostHogSDK.shared.capture(PostHogEvents.alert_save_permission_denied_cancel.rawValue)
                        
                    },
                    secondaryButton: .default(Text("Open Settings")) {
                        PostHogSDK.shared.capture(PostHogEvents.alert_save_permission_denied_settings.rawValue)
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
            )
            
            Spacer()
           
                
            VStack {
                Spacer()
                if isProcessing {
                    HStack {
                        Text("Processing ")
                        
                        ProgressView()
                    }
                    
                } else if finalImages == [] {
                    PhotosPicker(selection: $photosPickerItems, maxSelectionCount:MAX_SELECTION_COUNT, matching: .images) {
                        Image(selectedMockup.mockup.rawValue)
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                VStack {
                                    Text("Tap to add images")
                                        .bold()
                                        .foregroundStyle(.black)
                                    //                                    Text("Tap to add images")
                                    //                                        .font(.callout)
                                    //                                        .foregroundStyle(.gray)
                                }
                            }
                        
                    }
                } else if finalImages.count == 1 {
                    
                    PhotosPicker(selection: $photosPickerItems, maxSelectionCount:MAX_SELECTION_COUNT, matching: .images) {
                        Image(uiImage: finalImages[0])
                            .resizable()
                            .scaledToFit()
                        
                        
                    }
                    
                    HStack {
                        Spacer()
                        
                        PhotosPicker(selection: $replacePhotoPickerItem) {
                            HStack(spacing: 2) {
                                Image(systemName: "repeat")
                                    .font(.footnote)
                                Text("Replace")
                                    .font(.footnote)
                            }
                            .foregroundStyle(.white)
                            .padding(4)
                            .padding(.horizontal, 2)
                            
                            .background {
                                RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.8))
                            }
                            
                        }
                        
                        Spacer()
                        
                        if (paywallViewModel.viewState.isUserSubscribed != true) {
                            
                            Button {
                                PostHogSDK.shared.capture(PostHogEvents.mockup_remove_watermark.rawValue)
                                
                                routingViewModel.send(action: .updateUserFlow(userflow: .paywallWithLoading))
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "eraser.line.dashed")
                                        .font(.footnote)
                                    Text("Remove Watermark")
                                        .font(.footnote)
                                }
                                .foregroundStyle(.white)
                                .padding(4)
                                .padding(.horizontal, 2)
                                
                                .background {
                                    RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.8))
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                    }
                    
                } else {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        ScrollView(.horizontal) {
                            ScrollViewReader {reader in
                                
                                
                                
                                HStack {
                                    let width = UIScreen.main.bounds.width * 0.25
                                    let height = (selectedMockupType.rawValue == MockupType.mac.rawValue ? (UIScreen.main.bounds.width * 0.25 * 0.7) : (UIScreen.main.bounds.height * 0.2))
                                    ForEach(finalImages.indices, id: \.self) { index in
                                        Image(uiImage: finalImages[index])
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(color: .blue, radius: index == selectedFinalImageIndex ? 5 : 0)
                                            .frame(width: width , height: height )
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
                    
                    
                    Spacer()
                    
                    PhotosPicker(selection: $photosPickerItems, maxSelectionCount:MAX_SELECTION_COUNT, matching: .images) {
                        if selectedFinalImageIndex < finalImages.count {
                            Image(uiImage: finalImages[selectedFinalImageIndex])
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        if(!isProcessing && finalImages.count != 0) {
                            
                            Menu {
                                
                                Button("Low Quality") {
                                    
                                    if selectedFinalImageIndex < finalImages.count {
                                        saveImages(finalImagesArray: [finalImages[selectedFinalImageIndex]], quality: .low,via:.save)
                                        
                                    }
                                }
                                
                                Button("Medium Quality") {
                                    if selectedFinalImageIndex < finalImages.count {
                                        saveImages(finalImagesArray: [finalImages[selectedFinalImageIndex]], quality: .medium,via:.save)
                                        
                                    }
                                }
                                
                                Button("High Quality") {
                                    if selectedFinalImageIndex < finalImages.count {
                                        saveImages(finalImagesArray: [finalImages[selectedFinalImageIndex]], quality: .high,via:.save)
                                    }
                                }
                                
                                
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.footnote)
                                        .bold()
                                    Text("Save")
                                        .font(.footnote)
                                        .bold()
                                }
                                .foregroundStyle(.white)
                                .padding(4)
                                .padding(.horizontal, 2)
                                .background(RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.8)))
                                
                            }
                            
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $replacePhotoPickerItem) {
                            HStack(spacing: 2) {
                                Image(systemName: "repeat")
                                    .font(.footnote)
                                Text("Replace")
                                    .font(.footnote)
                            }
                            .foregroundStyle(.white)
                            .padding(4)
                            .padding(.horizontal, 2)
                            
                            .background {
                                RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.8))
                            }
                            
                        }
                        
                        Spacer()
                        
                        if (paywallViewModel.viewState.isUserSubscribed != true) {
                            
                            Button {
                                PostHogSDK.shared.capture(PostHogEvents.mockup_remove_watermark.rawValue)
                                
                                routingViewModel.send(action: .updateUserFlow(userflow: .paywallWithLoading))
                            } label: {
                                HStack(spacing: 2) {
                                    Image(systemName: "eraser.line.dashed")
                                        .font(.footnote)
                                    Text("Remove Watermark")
                                        .font(.footnote)
                                }
                                .foregroundStyle(.white)
                                .padding(4)
                                .padding(.horizontal, 2)
                                
                                .background {
                                    RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.8))
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                        
                        
                        
                    }
                    
                    Spacer()
                    
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
                                            PostHogSDK.shared.capture(PostHogEvents.mockup_device_.rawValue + item.mockup.rawValue)
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
                           
                            
                            Menu {
                                
                                Button("Fit") {
                                    PostHogSDK.shared.capture(PostHogEvents.mockup_image_fit.rawValue)
                                    contentMode = .fit
                                    finalImages = []
                                    processImages()
                                }
                                
                                Button("Fill") {
                                    PostHogSDK.shared.capture(PostHogEvents.mockup_image_fill.rawValue)
                                    contentMode = .fill
                                    finalImages = []
                                    processImages()
                                }
                                
                                Button("Stretch") {
                                    PostHogSDK.shared.capture(PostHogEvents.mockup_image_stretch.rawValue)
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
                           
                            
                            if finalImages.count > 0 {
                                NavigationLink {
                                    EditView(finalImages: finalImages).environmentObject(paywallViewModel)
                                        .environmentObject(routingViewModel)
                                        .environmentObject(moreViewModel)
                                } label: {
                                    Text("Edit")
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.horizontal, 4)
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue))
                                }
                            }
                            
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.black.opacity(0.1)))
                    
                    
                    if(!isProcessing && finalImages.count != 0){
                        
                        Menu {
                            
                            Button("Low Quality") {
                                saveImages(finalImagesArray: finalImages, quality: .low,via:.download)
                            }
                            
                            Button("Medium Quality") {
                                saveImages(finalImagesArray: finalImages, quality: .medium,via:.download)
                            }
                            
                            Button("High Quality") {
                                saveImages(finalImagesArray: finalImages, quality: .high,via:.download)
                            }
                            
                            
                        } label: {
                            Text(selectedImages.count == 1 ? "Save" : "Save All")
                                .font(.callout)
                                .foregroundStyle(.white)
                                .bold()
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
                            
                        }
                    }
                    
                    
                }
                .padding(.bottom)
                
                
                
                
                
                
            }
        
            VStack {
                
            }
            .alert("Mockup Saved Successfully" , isPresented: $showDownloadAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
            VStack {
                
            }
            .alert(isPresented: $showUpgradeAlert, content: {
                Alert(
                    title: Text("Free Mockups Left : \(moreViewModel.viewState.more.dailyFreeLimit)"),
                    message: Text("You can download up to \(DAILY_FREE_LIMIT) mockups per day for free. Upgrade to Pro for unlimited downloads."),
                    primaryButton: .cancel() {
                        PostHogSDK.shared.capture(PostHogEvents.alert_daily_limit_cancel.rawValue)
                        
                    },
                    secondaryButton: .default(Text("Unlock")) {
                        PostHogSDK.shared.capture(PostHogEvents.alert_daily_limit_unlock.rawValue)
                        
                        routingViewModel.send(action: .updateUserFlow(userflow: .paywall))
                        
                    }
                )
            }
            )
            
        }
//        .sheet(isPresented: $showBottomSheet, content: {
//
//            .presentationDetents([.medium])
//            
//        })
        .onAppear(perform: {
            if selectedImages != [] {
                processImages()
            }
            PostHogSDK.shared.capture(PostHogEvents.mockup_.rawValue + selectedMockupType.rawValue)
            
        })
        .onDisappear(perform: {
            finalImages.removeAll()
            selectedFinalImageIndex = 0
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
            PostHogSDK.shared.capture(PostHogEvents.mockup_image_replace.rawValue)
            
            if replacedImage != UIImage() {
                isProcessing = true
                DispatchQueue.global(qos: .userInitiated).async {
                    var image: UIImage = UIImage()
                    
                    if let resizedImage = ImageHelper.resizeImage(image: replacedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
                       let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                        if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup, addWatermark: paywallViewModel.viewState.isUserSubscribed ?? false ? false : true) {
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
            if photosPickerItems.count > 0 {
                PostHogSDK.shared.capture(PostHogEvents.mockup_image_uploaded.rawValue)
                
            }
            
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
        
        
        
        
        
    }
    
    func saveImages (finalImagesArray : [UIImage],quality: Quality,via : SaveOption) {
        
        
        switch via {
        case .download:
            PostHogSDK.shared.capture(PostHogEvents.mockup_.rawValue + "download_" + quality.rawValue)
        case .save:
            PostHogSDK.shared.capture(PostHogEvents.mockup_.rawValue + "save_" + quality.rawValue)
            
            
        case .saveWithBackground:
            PostHogSDK.shared.capture(PostHogEvents.mockup_.rawValue + "saveWithBackground_" + quality.rawValue)
        }
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .authorized {
            saveImagesToAlbum(finalImagesArray: finalImagesArray, quality: quality)
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    print("permission granted")
                    saveImagesToAlbum(finalImagesArray: finalImagesArray, quality: quality)
                    
                }
                else {
                    print("permission not granted")
                    showAccessDeniedAlert = true
                    PostHogSDK.shared.capture(PostHogEvents.alert_save_permission_denied.rawValue)
                }
            })
        } else {
            showAccessDeniedAlert = true
            PostHogSDK.shared.capture(PostHogEvents.alert_save_permission_denied.rawValue)
            
        }
        
    }
    
    
     func saveImagesToAlbum (finalImagesArray : [UIImage],quality: Quality) {
        if(paywallViewModel.viewState.isUserSubscribed ?? false){
            // if user is subscribed
            for image in finalImagesArray {
                ImageHelper.saveImageToPhotosAlbum(image: image, quality: quality)
            }
            showDownloadAlert = true
        } else {
            // if user is not subscribed
            // check the daily limit
            if(finalImagesArray.count > moreViewModel.viewState.more.dailyFreeLimit){
                // user has less/no limit left
                
                showUpgradeAlert = true
                print("it should show upgrade alert: \(showUpgradeAlert)")
            } else {
                // user has limit left
                for image in finalImagesArray {
                    ImageHelper.saveImageToPhotosAlbum(image: image, quality: quality)
                }
                let imagesCount = finalImagesArray.count
                let currLimit = moreViewModel.viewState.more.dailyFreeLimit
                moreViewModel.send(action: .updateDailyLimit(to: currLimit - imagesCount))
                moreViewModel.send(action: .setMore(moreType: .dailyFreeLimit))
                showDownloadAlert = true
                PostHogSDK.shared.capture(PostHogEvents.mockup_image_saved.rawValue)
            }
        }
        
    }
    
    func processImages() {
        autoreleasepool {
            
            
            isProcessing = true
            DispatchQueue.global(qos: .userInitiated).async {
                var imageArray: [UIImage] = []
                for selectedImage in selectedImages {
                    if let resizedImage = ImageHelper.resizeImage(image: selectedImage, targetSize: selectedMockup.baseImageSize, contentMode: contentMode, cornerRadius: selectedMockup.radius),
                       let overlayImage = UIImage(named: selectedMockup.mockup.rawValue) {
                        if let finalImage = ImageHelper.overlayImage(baseImage: resizedImage, overlayImage: overlayImage, mockup: selectedMockup, addWatermark: paywallViewModel.viewState.isUserSubscribed ?? false ? false : true) {
                            if let thumbnailImage = ImageHelper.resizeImage(image: finalImage, targetSize: finalImage.size, contentMode: .fit, cornerRadius: 0){
                                imageArray.append(thumbnailImage)
                                
                            }
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
    
    
    
  
}



struct ColorCircle: View {
    let color: Color?
    var body: some View {
        
        VStack {

            Image(systemName: "circle.fill")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(color)
                .background(.white)
                .clipShape(Circle())
        }
    }
}



//#Preview {
//    MockupView()
//}
