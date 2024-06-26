//
//  Constants.swift
//  Keys AI AI Keyboard
//
//  Created by Sachin Pandey on 22/02/24.
//

import Foundation
import RevenueCat


let APP_ID = "6504801633"

let RC_API_KEY = "appl_KLLriClfOsqsXDNZnvYoJxQMSAF"
//let APPS_FLYER_DEVKEY = "NbV4N3m54YbZrX6Gp7xypY"
let PRIVACY_POLICY = "https://zerovik.com/live-translator-privacy-policy/?u="+Purchases.shared.appUserID
let TERMS_OF_USE = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
let CUSTOMER_SUPPORT_URL = "https://tally.so/r/mJ22RY"
let FEEDBACK_FORM_URL = "https://tally.so/r/31rrKO"
let FEATURE_REQUEST_URL = "https://tally.so/r/wg55A1"
let APP_VERSION = "1.1.1"
let AMPLITUDE_API_KEY = ""



let dailyFreeLimit = "dailyFreeLimit"
let lastRunDate = "lastRunDate"
let totalApiCalls = "totalApiCalls"
let ratingShown = "ratingShown"
let npsShown = "npsShown"
let orderArray = "orderArray"

let LAMBDA_NO = "sou6UTri6i9mMqqdKKJ6W6H3s6gF2U2z3VyBTxcE"
let LAMBDA_TEXTRACT = "GjGjucqato16AF6tpX8bq9nXtUWyTa0B59dFGkdM"

#if DEBUG
let FREE_LIMIT = 100
#else
let FREE_LIMIT = 7
#endif
let DEFAULT_SPEED = 0.4
var appShareText = "Live Translator:\n https://apps.apple.com/us/app/id\(APP_ID)"


enum MockupList: String {
    case AppleWatchSeries6 = "Apple Watch Series 6"
    case AppleWatchSeries7 = "Apple Watch Series 7"
    case AppleWatchSeries8_41mm = "Apple Watch Series 8-41mm"
    case AppleWatchSeries8_45mm = "Apple Watch Series 8-45mm"
    case AppleWatchSeries9_41mm = "Apple Watch Series 9-41mm"
    case AppleWatchSeries9_45mm = "Apple Watch Series 9-45mm"
    case AppleWatchUltra = "Apple Watch Ultra"
    case AppleWatchUltra2 = "Apple Watch Ultra2"
    case iMac24 = "iMac 24"
    case iMac27 = "iMac 27"
    case iPad = "iPad 9th Gen"
    case iPadAir11 = "iPad Air 11"
    case iPadAir13 = "iPad Air 13"
    case iPadMini = "iPad Mini"
    case iPadPro11M4 = "iPad Pro 11 M4"
    case iPadPro13M4 = "iPad Pro 13 M4"
    case iPhone11ProMax = "iPhone 11 Pro Max"
    case iPhone11Pro = "iPhone 11 Pro"
    case iPhone11 = "iPhone 11"
    case iPhone12Mini = "iPhone 12 Mini"
    case iPhone12ProMax = "iPhone 12 Pro Max"
    case iPhone12Pro = "iPhone 12 Pro"
    case iPhone12 = "iPhone 12"
    case iPhone13mini = "iPhone 13 mini"
    case iPhone13ProMax = "iPhone 13 Pro Max"
    case iPhone13Pro = "iPhone 13 Pro"
    case iPhone13 = "iPhone 13"
    case iPhone14Plus = "iPhone 14 Plus"
    case iPhone14ProMax = "iPhone 14 Pro Max"
    case iPhone14Pro = "iPhone 14 Pro"
    case iPhone14 = "iPhone 14"
    case iPhone15Plus = "iPhone 15 Plus"
    case iPhone15ProMax = "iPhone 15 Pro Max"
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15 = "iPhone 15"
    case iPhoneSe = "iPhone SE"
    case MacBookAir13_4th_Gen = "MacBook Air 13 - 4th Gen"
    case MacBookPro14_5thGen = "MacBook Pro 14 - 5th Gen"
    case MacBookPro15_4thGen = "MacBook Pro 15 - 4th Gen"
    case MacBookPro16_4thGen = "MacBook Pro 16 - 4th Gen"
    case MacBookPro16_5thGen = "MacBook Pro 16 - 5th Gen"
}


struct MockupArray {
    
    
    
    static let iPhoneMockups : [Mockup] = [
        Mockup(mockup: MockupList.iPhone11, baseImageSize: CGSize(width: 828, height: 1792), radius: 0),
        Mockup(mockup: MockupList.iPhone11Pro, baseImageSize: CGSize(width: 1125, height: 2436), radius: 0),
        Mockup(mockup: MockupList.iPhone11ProMax, baseImageSize: CGSize(width: 1242, height: 2688), radius: 0),
        Mockup(mockup: MockupList.iPhone12Mini, baseImageSize: CGSize(width: 1125, height: 2436), radius: 0),
        Mockup(mockup: MockupList.iPhone12, baseImageSize: CGSize(width: 1170, height: 2532), radius: 0),
        Mockup(mockup: MockupList.iPhone12Pro, baseImageSize: CGSize(width: 1170, height: 2532), radius: 0),
        Mockup(mockup: MockupList.iPhone12ProMax, baseImageSize: CGSize(width: 1283, height: 2778), radius: 50),
        Mockup(mockup: MockupList.iPhone13mini, baseImageSize: CGSize(width: 1080, height: 2331), radius: 0),
        Mockup(mockup: MockupList.iPhone13, baseImageSize: CGSize(width: 1170, height: 2532), radius: 0),
        Mockup(mockup: MockupList.iPhone13Pro, baseImageSize: CGSize(width: 1170, height: 2532), radius: 0),
        Mockup(mockup: MockupList.iPhone13ProMax, baseImageSize: CGSize(width: 1284, height: 2778), radius: 50),
        Mockup(mockup: MockupList.iPhone14, baseImageSize: CGSize(width: 1170, height: 2532), radius: 0),
        Mockup(mockup: MockupList.iPhone14Plus, baseImageSize: CGSize(width: 1285, height: 2778), radius: 50),
        Mockup(mockup: MockupList.iPhone14Pro, baseImageSize: CGSize(width: 1179, height: 2556), radius: 50),
        Mockup(mockup: MockupList.iPhone14ProMax, baseImageSize: CGSize(width: 1290, height: 2796), radius: 50),
        Mockup(mockup: MockupList.iPhone15, baseImageSize: CGSize(width: 1179, height: 2556), radius: 50),
        Mockup(mockup: MockupList.iPhone15Plus, baseImageSize: CGSize(width: 1290, height: 2796), radius: 50),
        Mockup(mockup: MockupList.iPhone15Pro, baseImageSize: CGSize(width: 1179, height: 2556), radius: 50),
        Mockup(mockup: MockupList.iPhone15ProMax, baseImageSize: CGSize(width: 1290, height: 2796), radius: 50),
        Mockup(mockup: MockupList.iPhoneSe, baseImageSize: CGSize(width: 756, height: 1334), radius: 0) ]
    
    static let iPadMockups: [Mockup] = [
        Mockup(mockup: MockupList.iPadMini, baseImageSize: CGSize(width: 1488, height: 2266), radius: 0),
        Mockup(mockup: MockupList.iPadPro11M4, baseImageSize: CGSize(width: 1668, height: 2420), radius: 0),
        Mockup(mockup: MockupList.iPadPro13M4, baseImageSize: CGSize(width: 2064, height: 2752), radius: 0),
        Mockup(mockup: MockupList.iPadAir11, baseImageSize: CGSize(width: 1640, height: 2360), radius: 0),
        Mockup(mockup: MockupList.iPadAir13, baseImageSize: CGSize(width: 2048, height: 2732), radius: 0),
        Mockup(mockup: MockupList.iPad, baseImageSize: CGSize(width: 1620, height: 2160), radius: 0)
    ]
    
    static let macMockups: [Mockup] = [
        Mockup(mockup: MockupList.iMac24, baseImageSize: CGSize(width: 4482, height: 2522), radius: 0),
        Mockup(mockup: MockupList.iMac27, baseImageSize: CGSize(width: 5120, height: 2881), radius: 0),
        Mockup(mockup: MockupList.MacBookAir13_4th_Gen, baseImageSize: CGSize(width: 2560, height: 1664), radius: 0),
        Mockup(mockup: MockupList.MacBookPro15_4thGen, baseImageSize: CGSize(width: 2579, height: 1613), radius: 0),
        Mockup(mockup: MockupList.MacBookPro16_4thGen, baseImageSize: CGSize(width: 2965, height: 1856), radius: 0),
        Mockup(mockup: MockupList.MacBookPro14_5thGen, baseImageSize: CGSize(width: 3024, height: 1964), radius: 0),
        Mockup(mockup: MockupList.MacBookPro16_5thGen, baseImageSize: CGSize(width: 3458, height: 2236), radius: 0)
    ]
    
    static let appleWatchMockups: [Mockup] = [
        Mockup(mockup: MockupList.AppleWatchSeries6, baseImageSize: CGSize(width: 736, height: 896), radius: 0),
        Mockup(mockup: MockupList.AppleWatchSeries7, baseImageSize: CGSize(width: 792, height: 968), radius: 0),
        Mockup(mockup: MockupList.AppleWatchSeries8_45mm, baseImageSize: CGSize(width: 396, height: 484), radius: 0),
        Mockup(mockup: MockupList.AppleWatchSeries8_41mm, baseImageSize: CGSize(width: 352, height: 430), radius: 0),
        Mockup(mockup: MockupList.AppleWatchSeries9_45mm, baseImageSize: CGSize(width: 396, height: 484), radius: 0),
        Mockup(mockup: MockupList.AppleWatchSeries9_41mm, baseImageSize: CGSize(width: 352, height: 430), radius: 0),
        Mockup(mockup: MockupList.AppleWatchUltra, baseImageSize: CGSize(width: 410, height: 502), radius: 0),
        Mockup(mockup: MockupList.AppleWatchUltra2, baseImageSize: CGSize(width: 410, height: 502), radius: 0)
    ]
    
}





