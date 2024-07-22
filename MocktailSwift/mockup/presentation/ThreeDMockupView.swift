//
//  3dMockupView.swift
//  temp3dMockupGenerator
//
//  Created by Sachin Pandey on 15/07/24.
//

import SwiftUI
import SceneKit
import UIKit
import Photos

struct ThreeDMockupView: View {
    @State private var showImagePicker = false
        @State private var selectedImage: UIImage? = nil
    @State private var contentMode: ContentMode = .fit
    @State private var finalImage: UIImage? = nil
        
        var body: some View {
            VStack {
                ModelViewContainer(modelName: "iphone_15_pro_blue_titanium_no5g", selectedImage: $finalImage)
                    .padding()
                HStack {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Select Photo")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                                       NotificationCenter.default.post(name: .saveModelImage, object: nil)
                                   }) {
                                       Text("Save Model")
                                           .padding()
                                           .background(Color.green)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                   }
                    
                    Menu {
                        
                        Button("Fit") {
                            contentMode = .fit
                        }
                        
                        Button("Fill") {
                            contentMode = .fill
                        }
                        
                        Button("Stretch") {
                            contentMode = .stretch
                        }
                        
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text(contentMode.rawValue)
                                .fixedSize()
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal, 4)
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .bold()
                        }
                        .foregroundStyle(.black)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.black.opacity(0.1)))
                        
                    }
                               }
                           }
            .padding(.bottom, 4)
                           .sheet(isPresented: $showImagePicker) {
                               ImagePicker(selectedImage: $selectedImage)
                           }
                           .onChange(of: selectedImage) { oldValue, newValue in
                               if let selectedImage = selectedImage {
                                   if let imageFor3D = ImageHelper.resizeImageFor3DModel(image: selectedImage, frameSize: CGSize(width: 1024, height: 2048), contentMode: contentMode){
                                       finalImage = ImageHelper.resizeImage(image: imageFor3D, targetSize: imageFor3D.size, contentMode: .fit, cornerRadius: 0)
                                   }
                               }
                           }
                       }
                   }

                   struct ModelViewContainer: UIViewRepresentable {
                       var modelName: String
                       @Binding var selectedImage: UIImage?
                       
                       class Coordinator: NSObject, UIGestureRecognizerDelegate {
                           var sceneView: SCNView
                           var initialScale: Float = 1.0
                           var modelNode: SCNNode?
                           var initialPosition: SCNVector3 = SCNVector3Zero
                           var panStartLocation: CGPoint = .zero
                           var panStartModelPosition: SCNVector3 = SCNVector3Zero
                           var imageNode: SCNNode?
                           
                           init(_ control: ModelViewContainer) {
                               sceneView = SCNView()
                               super.init()
                               
                               // Load the USDZ model
                               guard let scene = try? SCNScene(url: Bundle.main.url(forResource: control.modelName, withExtension: "usdz")!) else {
                                   print("Failed to load model")
                                   return
                               }
                               sceneView.scene = scene
                               sceneView.contentScaleFactor = UIScreen.main.scale
                               //                               addLights(to: scene)
                               
                               sceneView.antialiasingMode = .multisampling4X
                               sceneView.autoenablesDefaultLighting = true
                               
                               //                               sceneView.scene?.background.contents = UIColor.red
                               sceneView.scene?.background.contents = UIColor.clear
                               
                               modelNode = scene.rootNode.childNodes.first
                               modelNode?.scale = SCNVector3(0.8, 0.8, 0.8)
                               
                               // Find the image node
                               imageNode = scene.rootNode.childNode(withName: "EHqmjTgFnPqroxg", recursively: true)

                               
                               // Enable gestures
                               let singleFingerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSingleFingerPan(_:)))
                               singleFingerPanGesture.minimumNumberOfTouches = 1
                               singleFingerPanGesture.maximumNumberOfTouches = 1
                               singleFingerPanGesture.delegate = self
                               sceneView.addGestureRecognizer(singleFingerPanGesture)
                               
                               let doubleFingerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDoubleFingerPan(_:)))
                               doubleFingerPanGesture.minimumNumberOfTouches = 2
                               doubleFingerPanGesture.maximumNumberOfTouches = 2
                               doubleFingerPanGesture.delegate = self
                               sceneView.addGestureRecognizer(doubleFingerPanGesture)
                               
                               let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
                               pinchGesture.delegate = self
                               sceneView.addGestureRecognizer(pinchGesture)
                               
                               NotificationCenter.default.addObserver(self, selector: #selector(saveModelImage), name: .saveModelImage, object: nil)
                           }
                           
                           deinit {
                               NotificationCenter.default.removeObserver(self)
                           }
                           
                           @objc func handleSingleFingerPan(_ sender: UIPanGestureRecognizer) {
                               guard let modelNode = modelNode else { return }
                               let translation = sender.translation(in: sceneView)
                               let angleX = Float(translation.y) * (Float.pi / 180)
                               let angleY = Float(translation.x) * (Float.pi / 180)
                               modelNode.eulerAngles.x -= angleX
                               modelNode.eulerAngles.y += angleY
                               sender.setTranslation(.zero, in: sceneView)
                           }
                           
                           @objc func handleDoubleFingerPan(_ sender: UIPanGestureRecognizer) {
                               guard let modelNode = modelNode else { return }
                                  
                                  if sender.state == .began {
                                      panStartModelPosition = modelNode.position
                                  }
                                  
                                  let translation = sender.translation(in: sceneView)
                                  
                                  // Convert the 2D translation to 3D space
                                  let translationVector = SCNVector3(Float(translation.x), Float(translation.y), 0)
                                  
                                  // Scale the translation to adjust sensitivity
                                  let scaleFactor: Float = 0.02 // Adjust this value to fine-tune sensitivity
                                  let scaledTranslation = translationVector.multiplied(by: scaleFactor)
                                  
                                  // Apply the translation to the model's starting position
                                  modelNode.position = SCNVector3(
                                      panStartModelPosition.x + scaledTranslation.x,
                                      panStartModelPosition.y - scaledTranslation.y, // Note the minus sign here
                                      panStartModelPosition.z
                                  )
                              
                               
                           }
                           
                           @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
                               guard let modelNode = modelNode else { return }
                               if sender.state == .began {
                                   initialScale = modelNode.scale.x
                               }
                               let scale = Float(sender.scale) * initialScale
                               modelNode.scale = SCNVector3(scale, scale, scale)
                           }
                           
                           func updateImage(_ image: UIImage?) {
                               guard let imageNode = imageNode, let image = image else { return }
                               let material = SCNMaterial()
                               material.diffuse.contents = image
                               imageNode.geometry?.firstMaterial = material
                           }
                           
                           func addLights(to scene: SCNScene) {
                                      // Ambient light
                                      let ambientLight = SCNLight()
                                      ambientLight.type = .ambient
                                      ambientLight.intensity = 1000
                                      let ambientNode = SCNNode()
                                      ambientNode.light = ambientLight
                                      scene.rootNode.addChildNode(ambientNode)
                                      
                                      // Directional light
                                      let directionalLight = SCNLight()
                                      directionalLight.type = .directional
                                      directionalLight.intensity = 1000
                                      let directionalNode = SCNNode()
                                      directionalNode.light = directionalLight
                                      directionalNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
                                      scene.rootNode.addChildNode(directionalNode)
                                  }
                           
                           @objc func saveModelImage() {
                               let renderer = UIGraphicsImageRenderer(size: sceneView.bounds.size)
                              
                               let image = renderer.image { context in
                                   sceneView.drawHierarchy(in: sceneView.bounds, afterScreenUpdates: true)
                               }
                              saveImageToPhotosGallery(image: image)
                           }
                           
                           func saveImageToPhotosGallery(image: UIImage) {
                               
                               if let data = image.pngData() {
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
                       //        // Convert CGImage to UIImage
                       //        let uiImage = UIImage(cgImage: image)
                       //
                       //        // Save UIImage to Photos gallery
                       //        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                           }
                       }
                       

                              
                       
                       func makeCoordinator() -> Coordinator {
                           Coordinator(self)
                       }
                       
                       func makeUIView(context: Context) -> SCNView {
                           context.coordinator.sceneView
                       }
                       
                       func updateUIView(_ uiView: SCNView, context: Context) {
                           context.coordinator.updateImage(selectedImage)
                       }
                   }

                   extension SCNVector3 {
                       static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
                           return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
                       }
                       func multiplied(by scalar: Float) -> SCNVector3 {
                               return SCNVector3(x * scalar, y * scalar, z * scalar)
                           }
                       

                   }

                   extension Notification.Name {
                       static let saveModelImage = Notification.Name("saveModelImage")
                   }

                   struct ImagePicker: UIViewControllerRepresentable {
                       @Binding var selectedImage: UIImage?
                       
                       class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                           var parent: ImagePicker
                           
                           init(parent: ImagePicker) {
                               self.parent = parent
                           }
                           
                           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                               if let image = info[.originalImage] as? UIImage {
                                   parent.selectedImage = image
                               }
                               picker.dismiss(animated: true)
                           }
                           
                           func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                               picker.dismiss(animated: true)
                           }
                       }
                       
                       func makeCoordinator() -> Coordinator {
                           Coordinator(parent: self)
                       }
                       
                       func makeUIViewController(context: Context) -> UIImagePickerController {
                           let picker = UIImagePickerController()
                           picker.delegate = context.coordinator
                           return picker
                       }
                       
                       func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
                   }

    
