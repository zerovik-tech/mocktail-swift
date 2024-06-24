//
//  ImageHelper.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import UIKit
import Photos

enum ContentMode: String {
    case fit = "Fit"
    case fill = "Fill"
    case stretch = "Stretch"
}

class ImageHelper {
    static func resizeImage(image: UIImage, targetSize: CGSize, contentMode: ContentMode, cornerRadius: CGFloat) -> UIImage? {
        let size = image.size
        var screenSize = targetSize
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        print("widthRatio: \(widthRatio)")
        print("heightRatio: \(heightRatio)")
        
        
        var newSize: CGSize
        var origin: CGPoint = .zero
        switch contentMode {
        case .fit:
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }
            screenSize = newSize
        case .fill:
           
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            } else {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            }
            screenSize = targetSize
            let xOffset = (targetSize.width - newSize.width) / 2.0
            let yOffset = (targetSize.height - newSize.height) / 2.0
            origin = CGPoint(x: xOffset, y: yOffset)
        case .stretch:
            newSize = targetSize
            screenSize = newSize


        }
       
        
        let rect = CGRect(origin: origin, size: newSize)
        
        
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 1.0)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        if cornerRadius != 0 {
          
         
            if (widthRatio >= 1 && widthRatio <= 1.5) && (heightRatio >= 1 && heightRatio <= 1.5) {
                print("target size width: \(targetSize.width), target size height: \(targetSize.height)")
                print("newsize width: \(newSize.width), newsize height: \(newSize.height)")
                path.addClip()
            }
        }
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func overlayImage(baseImage: UIImage, overlayImage: UIImage, mockup: Mockup) -> UIImage? {
        let cornerRadius = mockup.radius
        let size = overlayImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        var cornerPoint: CGPoint = CGPoint(x: ((size.width / 2) - (baseImage.size.width / 2)) , y: ((size.height / 2) - (baseImage.size.height / 2)))
        
        // these cases are used for non symmetrical mockups :
        
        if mockup.mockup.rawValue == MockupList.iMac24.rawValue{
            cornerPoint = CGPoint(x: cornerPoint.x, y: 159)
        } else if mockup.mockup.rawValue == MockupList.iMac27.rawValue {
            cornerPoint = CGPoint(x: cornerPoint.x, y: 249)
        } else if mockup.mockup.rawValue == MockupList.MacBookPro16_4thGen.rawValue {
            cornerPoint = CGPoint(x: cornerPoint.x, y: 112)
        } else if mockup.mockup.rawValue == MockupList.MacBookPro15_4thGen.rawValue {
            cornerPoint = CGPoint(x: cornerPoint.x, y: 196)
        }
        
       
        let baseRect = CGRect(origin: cornerPoint, size: baseImage.size)
        baseImage.draw(in: baseRect)
        
        
        let overlayRect = CGRect(origin: .zero, size: overlayImage.size)
        
        overlayImage.draw(in: overlayRect, blendMode: .normal, alpha: 1.0)
        
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        let newImageRect = CGRect(origin: .zero, size: size)
////        if cornerRadius != 0 {
////            
////        }
//        let path = UIBezierPath(roundedRect: newImageRect, cornerRadius: cornerRadius)
//        path.addClip()
//        newImage?.draw(in: newImageRect)
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        
        return newImage
    }
    
    static func saveImageToPhotosAlbum(image: UIImage) {
        // Convert UI Image into a PNG image
        if let resizedImage = resizeImage(image: image, targetSize: CGSize(width: image.size.width, height: image.size.height), contentMode: .fill, cornerRadius: 0){
            if let data = resizedImage.pngData() {
                // Save PNG image to Photos
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: data, options: nil)
                }, completionHandler: { success, error in
                    if success {
                        // Image saved to the Photos app
                        print("Image saved to the Photos app")
                    } else {
                        // Saving Image saved to the Photos app failed
                        print("Image saved to the Photos app")
                    }
                })
            }
        }
    }
    

}
