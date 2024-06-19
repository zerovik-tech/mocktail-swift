//
//  ImageHelper.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import UIKit

enum ContentMode: String {
    case fit = "Fit"
    case fill = "Fill"
    case stretch = "Stretch"
}

class ImageHelper {
    static func resizeImage(image: UIImage, targetSize: CGSize, contentMode: ContentMode) -> UIImage? {
        let size = image.size
        var screenSize = targetSize
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
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
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func overlayImage(baseImage: UIImage, overlayImage: UIImage, cornerRadius: CGFloat) -> UIImage? {
        let size = overlayImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let cornerPoint: CGPoint = CGPoint(x: ((size.width / 2) - (baseImage.size.width / 2)) , y: ((size.height / 2) - (baseImage.size.height / 2)))
        
       
        let baseRect = CGRect(origin: cornerPoint, size: baseImage.size)
        baseImage.draw(in: baseRect)
        
        
        let overlayRect = CGRect(origin: .zero, size: overlayImage.size)
        
        overlayImage.draw(in: overlayRect, blendMode: .normal, alpha: 1.0)
        
        
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let newImageRect = CGRect(origin: .zero, size: size)
        
        let path = UIBezierPath(roundedRect: newImageRect, cornerRadius: cornerRadius)
        path.addClip()
        newImage?.draw(in: newImageRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return finalImage
    }
    
    static func saveImageToPhotosAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
