////
////  tempView.swift
////  Mocktail
////
////  Created by Sachin Pandey on 22/07/24.
////
//
//import SwiftUI
//import SceneKit
//
//struct ContentView: View {
//    @State private var highResolutionImage: UIImage?
//
//    var body: some View {
//        VStack {
//            if let image = highResolutionImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            } else {
//                Text("Rendering...")
//            }
//        }
//        .onAppear {
//            renderHighResolutionImage()
//        }
//    }
//
//    func renderHighResolutionImage() {
//        // Create a SceneKit scene
//        let scene = createScene()
//        
//        // Set up the renderer
//        let renderer = SCNRenderer(device: nil, options: nil)
//        renderer.scene = scene
//
//        // Define the high-resolution size
//        let highResolutionSize = CGSize(width: 1920, height: 1080) // Example: 1920x1080
//
//        // Create an off-screen buffer
//        let highResolutionTexture = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: Int(highResolutionSize.width), height: Int(highResolutionSize.height), mipmapped: false)
//        highResolutionTexture.usage = [.renderTarget, .shaderRead]
//        let device = MTLCreateSystemDefaultDevice()!
//        let texture = device.makeTexture(descriptor: highResolutionTexture)!
//
//        // Render the scene into the off-screen buffer
//        let commandQueue = device.makeCommandQueue()!
//        let commandBuffer = commandQueue.makeCommandBuffer()!
//        let renderPassDescriptor = MTLRenderPassDescriptor()
//        renderPassDescriptor.colorAttachments[0].texture = texture
//        renderPassDescriptor.colorAttachments[0].loadAction = .clear
//        renderPassDescriptor.colorAttachments[0].storeAction = .store
//        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
//        
//        renderer.render(atTime: 0, viewport: CGRect(origin: .zero, size: highResolutionSize), commandBuffer: commandBuffer, passDescriptor: renderPassDescriptor)
//        commandBuffer.commit()
//        commandBuffer.waitUntilCompleted()
//
//        // Convert the rendered texture to UIImage
//        let highResolutionImage = texture.toUIImage()
//
//        // Downscale the high-resolution image to the display size
//        let displaySize = CGSize(width: 320, height: 240) // Example display size
//        let renderer = UIGraphicsImageRenderer(size: displaySize)
//        let downscaledImage = renderer.image { _ in
//            highResolutionImage.draw(in: CGRect(origin: .zero, size: displaySize))
//        }
//
//        // Update the state with the downscaled image
//        DispatchQueue.main.async {
//            self.highResolutionImage = downscaledImage
//        }
//    }
//
//    func createScene() -> SCNScene {
//        let scene = SCNScene()
//        guard let url = Bundle.main.url(forResource: "your_model", withExtension: "usdz") else {
//            return scene
//        }
//        let node = SCNNode()
//        node.loadUSDZModel(url: url)
//        scene.rootNode.addChildNode(node)
//        return scene
//    }
//}
//
//extension SCNNode {
//    func loadUSDZModel(url: URL) {
//        let asset = MDLAsset(url: url)
//        if let object = asset.object(at: 0) as? MDLObject {
//            let node = SCNNode(mdlObject: object)
//            addChildNode(node)
//        }
//    }
//}
//
//extension MTLTexture {
//    func toUIImage() -> UIImage {
//        let width = self.width
//        let height = self.height
//        let rowBytes = width * 4
//        var data = [UInt8](repeating: 0, count: Int(rowBytes * height))
//        self.getBytes(&data, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
//        
//        let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<UInt8>.size))
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let cgImageRef = CGImage(width: width,
//                                 height: height,
//                                 bitsPerComponent: 8,
//                                 bitsPerPixel: 32,
//                                 bytesPerRow: rowBytes,
//                                 space: CGColorSpaceCreateDeviceRGB(),
//                                 bitmapInfo: bitmapInfo,
//                                 provider: providerRef!,
//                                 decode: nil,
//                                 shouldInterpolate: true,
//                                 intent: .defaultIntent)!
//        return UIImage(cgImage: cgImageRef)
//    }
//}
//
