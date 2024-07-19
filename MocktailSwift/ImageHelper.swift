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
    
    
//    static func addBackground(image: UIImage, color backgroundColor: UIColor, aspectRatio: CGFloat) -> UIImage? {
//           autoreleasepool {
//               
//               
//               // Define the desired aspect ratio
//               let aspectRatio = aspectRatio
//               
//               // Calculate the new size based on the aspect ratio
//               var imageWidth: CGFloat = .zero
//               var newHeight: CGFloat = .zero
//               
//               if image.size.width > image.size.height {
//                   imageWidth = image.size.width * 1.4
//                   newHeight = imageWidth / aspectRatio
//               } else {
//                   newHeight = image.size.height * 1.4
//                   imageWidth = newHeight * aspectRatio
//               }
//               
//               print("imageWidth: \(imageWidth), newHeight: \(newHeight)")
//               // Create a CGRect for the new background with the desired aspect ratio
//               let backgroundRect = CGRect(x: 0, y: 0, width: imageWidth, height: newHeight)
//               
//               // Create a renderer with the background size
//               let renderer = UIGraphicsImageRenderer(size: backgroundRect.size)
//               
//               // Render the image with the background
//               let newImage = renderer.image { context in
//                   // Set the background color
//                   backgroundColor.setFill()
//                   context.fill(backgroundRect)
//                   
//                   // Calculate the position to draw the image to center it on the background
//                   let imageRect = CGRect(
//                       x: (backgroundRect.size.width - image.size.width) / 2.0,
//                       y: (backgroundRect.size.height - image.size.height) / 2.0,
//                       width: image.size.width,
//                       height: image.size.height
//                   )
//                   
//                   // Draw the image on top of the background
//                   image.draw(in: imageRect)
//               }
//               
//               return newImage
//           }
//          }
    
//  static  func addBackground(to image: UIImage, backgroundColor: UIColor, backgroundSize: CGSize) -> UIImage? {
//      autoreleasepool {
//          
//          
//          let renderer = UIGraphicsImageRenderer(size: backgroundSize)
//          let newImage = renderer.image { context in
//              // Fill the background with the specified color
//              backgroundColor.setFill()
//              context.fill(CGRect(origin: .zero, size: backgroundSize))
//              
//              // Calculate the aspect ratio
//              let aspectWidth = backgroundSize.width / image.size.width
//              let aspectHeight = backgroundSize.height / image.size.height
//              let aspectRatio = min(aspectWidth, aspectHeight)
//              
//              // Calculate the size to fit the image within the background
//              let scaledImageSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
//              
//              // Calculate the position to center the image
//              let x = (backgroundSize.width - scaledImageSize.width) / 2
//              let y = (backgroundSize.height - scaledImageSize.height) / 2
//              let imageRect = CGRect(x: x, y: y, width: scaledImageSize.width, height: scaledImageSize.height)
//              
//              // Draw the original image on top
//              image.draw(in: imageRect)
//          }
//          return newImage
//      }
//    }
       
    static func addBackground(to image: UIImage, backgroundColor: UIColor, gradientColors: [UIColor], backgroundType: MockupBackground, backgroundSize: CGSize, margin: CGFloat, offset: CGSize, rotation: CGFloat) -> UIImage? {
        autoreleasepool {
            
            
            let renderer = UIGraphicsImageRenderer(size: backgroundSize)
            let newImage = renderer.image { context in
                // Fill the background with the specified color
                if backgroundType == .linear {
                    backgroundColor.setFill()
                    context.fill(CGRect(origin: .zero, size: backgroundSize))
                } else {
                    let cgColors = gradientColors.map { $0.cgColor }
                            let colorSpace = CGColorSpaceCreateDeviceRGB()
                            let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil)
                            let startPoint = CGPoint(x: 0, y: 0)
                            let endPoint = CGPoint(x: backgroundSize.width, y: backgroundSize.height)
                            context.cgContext.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
                }
                
                
                // Calculate the maximum size for the image within the background considering the margin
                let maxImageSize = CGSize(width: backgroundSize.width - (2 * margin), height: backgroundSize.height - (2 * margin))
                
                // Calculate the aspect ratio
                let aspectWidth = maxImageSize.width / image.size.width
                let aspectHeight = maxImageSize.height / image.size.height
                let aspectRatio = min(aspectWidth, aspectHeight)
                
                // Calculate the size to fit the image within the background with the margin
                let scaledImageSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
                
                // Calculate the position to center the image with the margin
                let x = ((backgroundSize.width - scaledImageSize.width) / 2) + offset.width
                let y = ((backgroundSize.height - scaledImageSize.height) / 2) + offset.height
                let imageRect = CGRect(x: x, y: y, width: scaledImageSize.width, height: scaledImageSize.height)
                
                // Save the current graphics state
                context.cgContext.saveGState()
                        
                // Apply rotation around the center of the image
                context.cgContext.translateBy(x: imageRect.midX, y: imageRect.midY)
                context.cgContext.rotate(by: rotation)
                context.cgContext.translateBy(x: -imageRect.midX, y: -imageRect.midY)
                // Draw the original image on top
                image.draw(in: imageRect)
                
                // Restore the graphics state
                context.cgContext.restoreGState()
            }
            return newImage
        }
    

    }

   }

    


