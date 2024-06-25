//
//  Mockup.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 20/06/24.
//

import Foundation

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
