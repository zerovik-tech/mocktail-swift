//
//  ImageHelper.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import UIKit

class ImageHelper {
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
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
