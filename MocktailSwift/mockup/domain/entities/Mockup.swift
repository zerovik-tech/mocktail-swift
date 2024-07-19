//
//  Mockup.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 20/06/24.
//

import Foundation
import SwiftUI

struct Mockup: Identifiable, Equatable {
    let id = UUID()
    let mockup: MockupList
    let baseImageSize: CGSize
    let radius: CGFloat
}

enum MockupType: String {
    case iphone = "iphone"
    case ipad = "ipad"
    case mac = "mac"
    case appleWatch = "appleWatch"
}

enum Quality: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

enum DownloadMessage: String {
    case saved = "Mockup Saved Successfully"
    case error = "Error Saving Mockup"
}

struct PostFormatSize {
    static let instagramSqare: CGSize = CGSize(width: 1080, height: 1080)
    static let instagramStory: CGSize = CGSize(width: 1080, height: 1920)
    static let xLandscape: CGSize = CGSize(width: 1600, height: 900)
    static let xPotrait: CGSize = CGSize(width: 1080, height: 1350)
    static let xSquare: CGSize = CGSize(width: 1080, height: 1080)
    static let facebook: CGSize = CGSize(width: 1200, height: 630)
   
}

struct BackgroundColors {
    static let all: [Color] = [
            Color(red: 245/255, green: 245/255, blue: 245/255), // #F5F5F5
            Color(red: 211/255, green: 211/255, blue: 211/255), // #D3D3D3
            Color(red: 230/255, green: 230/255, blue: 250/255), // #E6E6FA
            Color(red: 245/255, green: 255/255, blue: 250/255), // #F5FFFA
            Color(red: 240/255, green: 255/255, blue: 240/255), // #F0FFF0
            Color(red: 255/255, green: 255/255, blue: 240/255), // #FFFFF0
            Color(red: 240/255, green: 248/255, blue: 255/255), // #F0F8FF
            Color(red: 255/255, green: 245/255, blue: 238/255), // #FFF5EE
            Color(red: 224/255, green: 255/255, blue: 255/255), // #E0FFFF
            Color(red: 253/255, green: 245/255, blue: 230/255), // #FDF5E6
            Color(red: 169/255, green: 169/255, blue: 169/255), // #A9A9A9 (Dark Gray)
            Color(red: 176/255, green: 196/255, blue: 222/255), // #B0C4DE (Light Steel Blue)
            Color(red: 188/255, green: 143/255, blue: 143/255), // #BC8F8F (Rosy Brown)
            Color(red: 144/255, green: 238/255, blue: 144/255), // #90EE90 (Light Green)
            Color(red: 205/255, green: 92/255, blue: 92/255)    // #CD5C5C (Indian Red)
        ]
}


