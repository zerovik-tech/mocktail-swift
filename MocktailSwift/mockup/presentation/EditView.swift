//
//  EditView.swift
//  Mocktail
//
//  Created by Sachin Pandey on 10/07/24.
//

import SwiftUI
import PostHog
import PhotosUI

enum Adjustment: String {
    case margin
    case rotate
}

enum MockupBackground: String {
    case linear
    case gradient
    
}

struct EditView: View {
    @EnvironmentObject var paywallViewModel : PaywallViewModel
    @EnvironmentObject var routingViewModel : RoutingViewModel
    @EnvironmentObject var moreViewModel : MoreViewModel
    
    @State var finalImages: [UIImage]
    @State private var imagesWithBackground: [UIImage] = []
    @State private var imagesWithBackgroundIndex = 0
    @State private var isProcessing = false
    @State private var mockupBackground: Color = .white
    @State private var showDownloadAlert = false
    @State private var showUpgradeAlert : Bool = false
    @State private var showAccessDeniedAlert : Bool = false
    @State private var workItem: DispatchWorkItem?
    
    
    @State private var applyToAll = false
    @State private var isBackgroundAdded = false
    @State private var margin: CGFloat = 0
    @State private var rotationAngle: CGFloat = 0
    @State private var imageSize = PostFormatSize.instagramSqare
    @State private var mockupBackgroundType: MockupBackground = .linear
    @State private var gradient1: Color = .white
    @State private var gradient2: Color = .gray
    @State private var initialPosition: CGSize = .zero
    @State private var finalPosition : CGSize = .zero
    @State private var adjustment : Adjustment = .margin
    @State private var scalingFactor: CGFloat = 1
    @State private var didMove = false
    @State private var frameWidth: CGFloat = 0
    @State private var frameHeight: CGFloat = 0
    var body: some View {
        VStack {
            //            HStack{
            //                HStack {
            //                    Image(systemName: "chevron.left")
            //                        .font(.title3)
            //                        .bold()
            //                    Text("Mockup Edits")
            //                        .font(.title3)
            //                        .bold()
            //                }
            //                .padding()
            //                .onTapGesture {
            //                    showEditView = false
            //                }
            //
            //                Spacer()
            //            }
            //            .padding(.horizontal)
            //            .alert(isPresented: $showUpgradeAlert, content: {
            //                Alert(
            //                    title: Text("Free Mockups Left : \(moreViewModel.viewState.more.dailyFreeLimit)"),
            //                    message: Text("You can download up to \(DAILY_FREE_LIMIT) mockups per day for free. Upgrade to Pro for unlimited downloads."),
            //                    primaryButton: .cancel() {
            //                        PostHogSDK.shared.capture(PostHogEvents.alert_daily_limit_cancel.rawValue)
            //
            //                    },
            //                    secondaryButton: .default(Text("Unlock")) {
            //                        PostHogSDK.shared.capture(PostHogEvents.alert_daily_limit_unlock.rawValue)
            //
            //                        routingViewModel.send(action: .updateUserFlow(userflow: .paywall))
            //
            //                    }
            //                )
            //            }
            //            )
            //            Text("Instagram Post")
            //                .bold()
            //                .onTapGesture {
            //                    selectedAspectRatio = PostAspectRatio.instagram
            //                    addBackground(aspectRatio: selectedAspectRatio)
            //                }
            //            Text("Facebook Post")
            //                .bold()
            //                .onTapGesture {
            //                    selectedAspectRatio = PostAspectRatio.facebook
            //                    addBackground(aspectRatio: selectedAspectRatio)
            //                }
            //            Text("Twitter Post")
            //                .bold()
            //                .onTapGesture {
            //                    selectedAspectRatio = PostAspectRatio.twitter
            //                    addBackground(aspectRatio: selectedAspectRatio)
            //                }
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
            VStack{
                
                
                
                let adjustedMargin = margin * (frameWidth / imageSize.width)
                ZStack {
                    Rectangle()
                        .frame(
                            width: frameWidth ,
                            height: frameHeight
                        )
                        .foregroundStyle(mockupBackgroundType == .linear ? AnyShapeStyle(mockupBackground) :
                                            AnyShapeStyle(
                                                LinearGradient(
                                                    colors: [gradient1, gradient2],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ))
                        )
                    
                    if (finalImages.count == 1) {
                        HStack{
                            Spacer()
                            Image(uiImage: finalImages[0])
                                .resizable()
                                .scaledToFit()
                                .padding(adjustedMargin)
                                .frame(
                                    width: frameWidth ,
                                    height: frameHeight
                                )
                                .rotationEffect(Angle(degrees: rotationAngle))
                                .offset(finalPosition)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            print("value: \(value)")
                                            print("translation: \(value.translation)")
                                            
                                            
                                            if didMove == false {
                                                didMove = true
                                                initialPosition = finalPosition
                                            }
                                            finalPosition.width = initialPosition.width + value.translation.width
                                            finalPosition.height = initialPosition.height + value.translation.height
                                            print("finalPosition: \(finalPosition)")
                                        }
                                        .onEnded { _ in
                                            initialPosition = .zero
                                            didMove = false
                                        }
                                )
                                                            .mask(
                                                                Rectangle()
                                                                    .frame(
                                                                        width: frameWidth ,
                                                                        height: frameHeight
                                                                    )
                            
                                                                //                                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                                            )
                                .padding(.vertical)
                            Spacer()
                        }
                        
                    }else {
                        ScrollView(.horizontal){
                            HStack {
                                VStack{
                                    
                                }
                                .frame(width: 10)
                                
                                ForEach(finalImages.indices, id: \.self) { index in
                                    Image(uiImage: finalImages[0])
                                        .resizable()
                                        .scaledToFit()
                                        .padding(adjustedMargin)
                                        .frame(
                                            width: frameWidth ,
                                            height: frameHeight
                                        )
                                        .background(mockupBackgroundType == .linear ? AnyView(mockupBackground) :
                                                        AnyView(
                                                            LinearGradient(
                                                                colors: [gradient1, gradient2],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            ))
                                        )
                                        .padding(.vertical)
                                }
                                
                                VStack{
                                    
                                }
                                .frame(width: 10)
                            }
                        }
                        
                    }
                }
                .onAppear{
                    print("imagesize: \(imageSize)")
                    
                    if imageSize.width >= imageSize.height{
                         frameWidth = UIScreen.main.bounds.width * 0.9
                         frameHeight = frameWidth * (imageSize.height / imageSize.width)
                    } else {
                        frameHeight = UIScreen.main.bounds.height * 0.35
                    frameWidth = frameHeight * (imageSize.width / imageSize.height)
                    }
                    scalingFactor = (frameWidth / imageSize.width)
                }
                .onChange(of: imageSize) { oldValue, newValue in
                    
                    if imageSize.width >= imageSize.height{
                         frameWidth = UIScreen.main.bounds.width * 0.9
                         frameHeight = frameWidth * (imageSize.height / imageSize.width)
                    } else {
                        frameHeight = UIScreen.main.bounds.height * 0.35
                    frameWidth = frameHeight * (imageSize.width / imageSize.height)
                    }
                    scalingFactor = (frameWidth / imageSize.width)
                }
                
           
        }
           
            
            
            
            VStack(spacing: 0){
                HStack {
                    Text("Format")
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal){
                    HStack {
                        HStack{
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Instagram Story")
                                    .font(.footnote)
                                    .bold()
                                Text("1080 x 1920 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.instagramStory ? 0.1 : 0)))
                        .onTapGesture {
                            imageSize = PostFormatSize.instagramStory
                        }
                        
                        HStack{
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Instagram Post")
                                    .font(.footnote)
                                    .bold()
                                Text("1080 x 1080 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.instagramSqare ? 0.1 : 0)))
                        .onTapGesture {
                            
                            imageSize = PostFormatSize.instagramSqare
                        }
                        
                        HStack{
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Landscape")
                                    .font(.footnote)
                                    .bold()
                                Text("1600 x 900 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.xLandscape ? 0.1 : 0)))
                        .onTapGesture {
                            imageSize = PostFormatSize.xLandscape
                        }
                        
                        HStack{
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Square")
                                    .font(.footnote)
                                    .bold()
                                Text("1080 x 1080 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.xSquare ? 0.1 : 0)))
                        .onTapGesture {
                            imageSize = PostFormatSize.xSquare
                        }
                        
                        HStack{
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Portrait")
                                    .font(.footnote)
                                    .bold()
                                Text("1080 x 1350 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.xPotrait ? 0.1 : 0)))
                        .onTapGesture {
                            imageSize = PostFormatSize.xPotrait
                        }
                        
                        HStack{
                            Image("facebook")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading){
                                Text("Facebook Post")
                                    .font(.footnote)
                                    .bold()
                                Text("1200 x 630 px")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black.opacity(imageSize == PostFormatSize.facebook ? 0.1 : 0)))
                        .onTapGesture {
                            imageSize = PostFormatSize.facebook
                        }
                        
                        
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            
            VStack(spacing: 4) {
                
                HStack {
                    Text("Mockup Background")
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Linear")
                        .font(.footnote)
                        .foregroundStyle(mockupBackgroundType == MockupBackground.linear ? .white : .black)
                        .padding(2)
                        .background(RoundedRectangle(cornerRadius: 6).fill(mockupBackgroundType == MockupBackground.linear ? .black.opacity(0.4) : .black.opacity(0)))
                        .onTapGesture {
                            mockupBackgroundType = .linear
                        }
                    
                    Text("Gradient")
                        .font(.footnote)
                        .foregroundStyle(mockupBackgroundType == MockupBackground.gradient ? .white : .black)
                        .padding(2)
                        .background(RoundedRectangle(cornerRadius: 6).fill(mockupBackgroundType == MockupBackground.gradient ? .black.opacity(0.4) : .black.opacity(0)))
                        .onTapGesture {
                            mockupBackgroundType = .gradient
                        }
                }
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.2)))
                
                if mockupBackgroundType == .linear{
                    ScrollView(.horizontal) {
                        
                        HStack{
                            
                            ColorPicker(selection: $mockupBackground) {
                                Text("")
                            }
                            ColorCircle(color: .black)
                                .onTapGesture {
                                    mockupBackground = .black
                                }
                            ColorCircle(color: .white)
                                .onTapGesture {
                                    mockupBackground = .white
                                }
                            ColorCircle(color: .blue)
                                .onTapGesture {
                                    mockupBackground = .blue
                                }
                            ColorCircle(color: .red)
                                .onTapGesture {
                                    mockupBackground = .red
                                }
                            ColorCircle(color: .yellow)
                                .onTapGesture {
                                    mockupBackground = .yellow
                                }
                            
                            
                            
                        }
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2)))
                    .padding(.horizontal)
                    
                } else {
                    
                    
                    HStack{
                        
                        
                        
                        ColorPicker(selection: $gradient1) {
                            Text("")
                        }
                        .padding(.horizontal)
                        .labelsHidden()
                        
                        
                        
                        
                        ColorPicker(selection: $gradient2) {
                            Text("")
                        }
                        .padding(.horizontal)
                        .labelsHidden()
                        
                        
                        
                    }
                    
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2)))
                    .padding(.horizontal)
                    
                }
                
            }
            
            //            .onChange(of: mockupBackgroundType) { oldValue, newValue in
            //                if newValue == MockupBackground.linear {
            //                    mockupBackground = .white
            //                } else {
            //                    let color = Gradient(colors: [gradient1, gradient2])
            //                }
            //
            //            }
            VStack(spacing: 4) {
            HStack {
                HStack{
                    Text("Margin:")
                    Text("\(Int(margin))")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundStyle(adjustment == Adjustment.margin ? .white : .black)
                .padding(2)
                .background(RoundedRectangle(cornerRadius: 6).fill(adjustment == Adjustment.margin ? .black.opacity(0.4) : .black.opacity(0)))
                .onTapGesture {
                    adjustment = .margin
                }
                HStack{
                    Text("Rotate:")
                    Text("\(Int(rotationAngle))")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                    .font(.footnote)
                    .foregroundStyle(adjustment == Adjustment.rotate ? .white : .black)
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 6).fill(adjustment == Adjustment.rotate ? .black.opacity(0.4) : .black.opacity(0)))
                    .onTapGesture {
                        adjustment = .rotate
                    }
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 6).fill(.black.opacity(0.2)))
            
            
            
            if adjustment == .margin {
                Slider(value: $margin, in: 0...200, step: 1)
                {
                    Text("")
                } minimumValueLabel: {
                    Text("0")
                        .foregroundStyle(.black)
                } maximumValueLabel: {
                    Text("200")
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)
            } else {
                
                Slider(value: $rotationAngle, in: 0...360, step: 1)
                {
                    Text("")
                } minimumValueLabel: {
                    Text("0")
                        .foregroundStyle(.black)
                } maximumValueLabel: {
                    Text("360")
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)
            }
        }
            
            
            Spacer()
            
            
            if  !isProcessing {
                Menu {
                    
                    Button("Low Quality") {
                        
                        saveImages(quality: .low, via: .saveWithBackground)
                    }
                    
                    Button("Medium Quality") {
                        saveImages(quality: .medium,via:.saveWithBackground)
                    }
                    
                    Button("High Quality") {
                        saveImages(quality: .high,via:.saveWithBackground)
                    }
                    
                    
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.footnote)
                            .bold()
                        Text("Save")
                            .font(.headline)
                            .bold()
                    }
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal, 2)
                    
                    
                    
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
            } else {
                HStack {
                    Text("Processing ")
                    
                    ProgressView()
                }
            }
            
        }
        .padding(.bottom)
        .background(.black.opacity(0.1))
        .navigationTitle("Mockup Edits")
        //        .onAppear {
        //            imagesWithBackground = finalImages
        //        }
        
    }
    
    func addBackground(completion: @escaping () -> Void) {
        print("scaling factor:",scalingFactor)
        print("finalpositionwidth: \(finalPosition.width)")
        print("offset width: \(finalPosition.width / (scalingFactor))")
        print("offser height: \(finalPosition.height / (scalingFactor))")
        if finalImages.count > 0 {
            isProcessing = true
            DispatchQueue.global(qos: .userInitiated).async {
                
                var finalImageArray: [UIImage] = []
                for image in finalImages {
                    
                    if let imageWithBackground = ImageHelper.addBackground(to: image, backgroundColor: UIColor(mockupBackground), gradientColors: [UIColor(gradient1), UIColor(gradient2)], backgroundType: mockupBackgroundType, backgroundSize: imageSize, margin: margin, offset: CGSize(width: finalPosition.width / (scalingFactor), height: finalPosition.height / (scalingFactor)) , rotation: ((rotationAngle * .pi) / 180)){
                        if let resizedImage = ImageHelper.resizeImage(image: imageWithBackground, targetSize: imageWithBackground.size, contentMode: .fit, cornerRadius: 0) {
                            finalImageArray.append(resizedImage)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    imagesWithBackground = finalImageArray
                    
                    isBackgroundAdded = true
                    print("add background completed")
                    completion()
                }
            }
        }
        else {
            completion()
        }
    }
    
    
    func saveImages (quality: Quality,via : SaveOption) {
        
        
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
            saveImagesToAlbum(quality: quality)
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    print("permission granted")
                    saveImagesToAlbum(quality: quality)
                    
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
    
    
    func saveImagesToAlbum (quality: Quality) {
        addBackground{
            if(paywallViewModel.viewState.isUserSubscribed ?? false){
                // if user is subscribed
                for image in imagesWithBackground {
                    ImageHelper.saveImageToPhotosAlbum(image: image, quality: quality)
                }
                isProcessing = false
                showDownloadAlert = true
            } else {
                // if user is not subscribed
                // check the daily limit
                if(imagesWithBackground.count > moreViewModel.viewState.more.dailyFreeLimit){
                    // user has less/no limit left
                    isProcessing = false
                    showUpgradeAlert = true
                    print("it should show upgrade alert: \(showUpgradeAlert)")
                } else {
                    // user has limit left
                    for image in imagesWithBackground {
                        ImageHelper.saveImageToPhotosAlbum(image: image, quality: quality)
                    }
                    let imagesCount = imagesWithBackground.count
                    let currLimit = moreViewModel.viewState.more.dailyFreeLimit
                    moreViewModel.send(action: .updateDailyLimit(to: currLimit - imagesCount))
                    moreViewModel.send(action: .setMore(moreType: .dailyFreeLimit))
                    isProcessing = false
                    showDownloadAlert = true
                    PostHogSDK.shared.capture(PostHogEvents.mockup_image_saved.rawValue)
                }
            }
        }
        
    }
}
