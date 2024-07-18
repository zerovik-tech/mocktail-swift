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
        autoreleasepool {
            
            
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
            
            
            image.draw(in: rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContextWithOptions(screenSize, false, 1.0)
            let newRect = CGRect(origin: .zero, size: screenSize)
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: screenSize), cornerRadius: 50)
            
            if let newImage = newImage {
                let newWidthRatio = targetSize.width / newImage.size.width
                let newHeightRatio = targetSize.height / newImage.size.height
                print("newWidthRatio: \(newWidthRatio)")
                print("newHeightRatio: \(newHeightRatio)")
                if cornerRadius != 0 {
                    
                    
                    if (newWidthRatio >= 1 && newWidthRatio <= 1.2) && (newHeightRatio >= 1 && newHeightRatio <= 1.2) {
                        path.addClip()
                    }
                }
                
            }
            
            newImage?.draw(in: newRect)
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }
    }
    
    static func overlayImage(baseImage: UIImage, overlayImage: UIImage, mockup: Mockup,addWatermark : Bool) -> UIImage? {
        autoreleasepool {
            
            
            
            let cornerRadius = mockup.radius
            let size = overlayImage.size
            UIGraphicsBeginImageContextWithOptions(mockup.baseImageSize, false, 0.0)
            
            var baseImageOrigin = CGPoint(x: ((size.width / 2) - (mockup.baseImageSize.width / 2)) , y: ((size.height / 2) - (mockup.baseImageSize.height / 2)))
            
            // these cases are used for non symmetrical mockups :
            
            if mockup.mockup.rawValue == MockupList.iMac24.rawValue{
                baseImageOrigin = CGPoint(x: baseImageOrigin.x, y: 159 )
            } else if mockup.mockup.rawValue == MockupList.iMac27.rawValue {
                baseImageOrigin = CGPoint(x: baseImageOrigin.x, y: 249 )
            } else if mockup.mockup.rawValue == MockupList.MacBookPro16_4thGen.rawValue {
                baseImageOrigin = CGPoint(x: baseImageOrigin.x, y: 112 )
            } else if mockup.mockup.rawValue == MockupList.MacBookPro15_4thGen.rawValue {
                baseImageOrigin = CGPoint(x: baseImageOrigin.x, y: 196 )
            }
            
            // Define the background rect based on mockup.baseImageSize
            let backgroundRect = CGRect(origin: .zero, size: mockup.baseImageSize)
            
            if mockup.radius != 0 {
                let path = UIBezierPath(roundedRect: backgroundRect, cornerRadius: mockup.radius)
                path.addClip()
                
            }
            
            // Draw the white background
            UIColor.white.setFill()
            UIRectFill(backgroundRect)
            
            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            let rect = CGRect(origin: baseImageOrigin, size: mockup.baseImageSize)
            
            backgroundImage?.draw(in: rect)
            
            var cornerPoint: CGPoint = CGPoint(x: ((size.width / 2) - (baseImage.size.width / 2)) , y: ((size.height / 2) - (baseImage.size.height / 2)))
            
            // these cases are used for non symmetrical mockups :
            
            if mockup.mockup.rawValue == MockupList.iMac24.rawValue{
                cornerPoint = CGPoint(x: cornerPoint.x, y: 159 + ((mockup.baseImageSize.height / 2) - (baseImage.size.height / 2)))
            } else if mockup.mockup.rawValue == MockupList.iMac27.rawValue {
                cornerPoint = CGPoint(x: cornerPoint.x, y: 249 + ((mockup.baseImageSize.height / 2) - (baseImage.size.height / 2)))
            } else if mockup.mockup.rawValue == MockupList.MacBookPro16_4thGen.rawValue {
                cornerPoint = CGPoint(x: cornerPoint.x, y: 112 + ((mockup.baseImageSize.height / 2) - (baseImage.size.height / 2)))
            } else if mockup.mockup.rawValue == MockupList.MacBookPro15_4thGen.rawValue {
                cornerPoint = CGPoint(x: cornerPoint.x, y: 196 + ((mockup.baseImageSize.height / 2) - (baseImage.size.height / 2)))
            }
            
            
            let baseRect = CGRect(origin: cornerPoint, size: baseImage.size)
            baseImage.draw(in: baseRect)
            
            if(addWatermark){
                let waterMarkImage = UIImage(named: "Made with Mocktail")
                if let waterMarkImage = waterMarkImage {
                    let watermarkSize = CGSize(width: mockup.baseImageSize.width * 0.4, height: mockup.baseImageSize.width * 0.4 * 190 / 1526)
                    var waterMarkOrigin = CGPoint(x: ((size.width / 2) - (watermarkSize.width / 2)) , y: ((((size.height - mockup.baseImageSize.height) / 2) + (mockup.baseImageSize.height - watermarkSize.height)) - size.height * 0.025))
                    
                    // these cases are used for non symmetrical mockups :
                    
                    if mockup.mockup.rawValue == MockupList.iMac24.rawValue{
                        waterMarkOrigin = CGPoint(x: waterMarkOrigin.x, y: (159 + (mockup.baseImageSize.height - watermarkSize.height)) - size.height * 0.025)
                    } else if mockup.mockup.rawValue == MockupList.iMac27.rawValue {
                        waterMarkOrigin = CGPoint(x: waterMarkOrigin.x, y: (249 + (mockup.baseImageSize.height - watermarkSize.height)) - size.height * 0.025)
                    } else if mockup.mockup.rawValue == MockupList.MacBookPro16_4thGen.rawValue {
                        waterMarkOrigin = CGPoint(x: waterMarkOrigin.x, y: (112 + (mockup.baseImageSize.height - watermarkSize.height)) - size.height * 0.025)
                    } else if mockup.mockup.rawValue == MockupList.MacBookPro15_4thGen.rawValue {
                        waterMarkOrigin = CGPoint(x: waterMarkOrigin.x, y: (196 + (mockup.baseImageSize.height - watermarkSize.height)) - size.height * 0.025)
                    }
                    
                    let waterMarkRect = CGRect(origin: waterMarkOrigin, size: watermarkSize)
                    waterMarkImage.draw(in: waterMarkRect, blendMode: .normal, alpha: 0.5)
                    
                    
                } else {
                    print("Image not available")
                }
            }
            
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
    }
    
    static func saveImageToPhotosAlbum(image: UIImage, quality: Quality) {
        // Convert UI Image into a PNG image
        switch quality {
        case .low:
            if let resizedImage = resizeImage(image: image, targetSize: CGSize(width: image.size.width * 0.6, height: image.size.height * 0.6), contentMode: .fill, cornerRadius: 0){
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
                            print("Saving Image saved to the Photos app failed")
                        }
                    })
                }
            }
        case .medium:
            if let resizedImage = resizeImage(image: image, targetSize: CGSize(width: image.size.width * 0.8, height: image.size.height * 0.8), contentMode: .fill, cornerRadius: 0){
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
                            print("Saving Image saved to the Photos app failed")
                        }
                    })
                }
            }
        case .high:
           
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
                            print("Saving Image saved to the Photos app failed")
                        }
                    })
                }
            }
            
        }

    }
    
    
    static func resizeImageFor3DModel(image: UIImage, frameSize: CGSize, contentMode: ContentMode) -> UIImage? {
        autoreleasepool {
                   let renderer = UIGraphicsImageRenderer(size: frameSize)
                   let newImage = renderer.image { context in
                       // Calculate the drawing rect based on content mode and image aspect ratio
                       var drawingRect = CGRect(origin: .zero, size: frameSize)
                       
                       let imageSize = image.size
                       let aspectRatio = imageSize.width / imageSize.height
                       
                       switch contentMode {
                       case .fit:
                           // Aspect fit: scale to fit within frameSize, centering the image
                           let targetAspectRatio = frameSize.width / frameSize.height
                           if aspectRatio > targetAspectRatio {
                               drawingRect.size.width = frameSize.width
                               drawingRect.size.height = frameSize.width / aspectRatio
                           } else {
                               drawingRect.size.height = frameSize.height
                               drawingRect.size.width = frameSize.height * aspectRatio
                           }
                           drawingRect.origin.x = (frameSize.width - drawingRect.size.width) / 2
                           drawingRect.origin.y = (frameSize.height - drawingRect.size.height) / 2
                       case .fill:
                           // Aspect fill: scale to fill the entire frameSize, clipping excess
                           if imageSize.width > imageSize.height {
                               drawingRect.size.height = frameSize.height
                               drawingRect.size.width = frameSize.height * aspectRatio
                               drawingRect.origin.x = (frameSize.width - drawingRect.size.width) / 2
                           } else {
                               drawingRect.size.width = frameSize.width
                               drawingRect.size.height = frameSize.width / aspectRatio
                               drawingRect.origin.y = (frameSize.height - drawingRect.size.height) / 2
                           }
                       case .stretch:
                           // Stretch: fill the entire frameSize, possibly distorting the image
                           drawingRect = CGRect(origin: .zero, size: frameSize)
                       }
                       
                       // Fill the background with white
                       UIColor.white.setFill()
                       context.fill(CGRect(origin: .zero, size: frameSize))
                       
                       // Draw the image in the calculated rect
                       image.draw(in: drawingRect)
                   }
                   return newImage
               }
    }

}
