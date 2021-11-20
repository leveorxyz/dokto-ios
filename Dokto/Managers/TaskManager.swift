//
//  TaskManager.swift
//  Dokto
//
//  Created by Rupak on 11/19/21.
//

import UIKit
import Photos

class TaskManager: NSObject {
    static let shared = TaskManager()
    
    var imagePicker = UIImagePickerController()
    var imagePickerCompletion: ((UIImage) -> Void)?
    var expectedImageSize = CGSize(width: 512, height: 512)
}

//MARK: Photo & library
extension TaskManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func getPhotoWith(size: CGSize? = nil,
                      _ completion: @escaping(_ image: UIImage) -> Void) {
        self.imagePickerCompletion = completion
        if let size = size {
            self.expectedImageSize = size
        }
        
        let alertController = UIAlertController.init(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (alertAction) in
            self.checkCameraPermission { (hasAccess) in
                if hasAccess {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                } else {
                    AlertManager.showCameraPermissionAlert()
                }
            }
        }))
        alertController.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (alertAction) in
            self.checkPhotoLibraryPermission { (hasAccess) in
                if hasAccess {
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
                } else {
                    AlertManager.showLibraryPermissionAlert()
                }
            }
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        UIApplication.rootViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: { () -> Void in
            if let image = info[.originalImage] as? UIImage, let resized = image.resize(withSize: CGSize.init(width: self.expectedImageSize.width, height: self.expectedImageSize.height*(image.size.width/image.size.height))) {
                self.imagePickerCompletion?(resized)
            }
        })
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.cameraDevice = .front
            
            self.imagePicker.modalPresentationStyle = .overCurrentContext
            UIApplication.rootViewController()?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            
            self.imagePicker.modalPresentationStyle = .overCurrentContext
            UIApplication.rootViewController()?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func checkPhotoLibraryPermission(_ completion: @escaping(_ hasAccess: Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
            break
        case .denied, .restricted:
            completion(false)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    completion(true)
                    break
                case .denied, .restricted:
                    completion(false)
                    break
                case .notDetermined:
                    completion(false)
                    break
                case .limited:
                    completion(true)
                    break
                @unknown default:
                    completion(false)
                }
            }
        case .limited:
            completion(true)
            break
        @unknown default:
            completion(false)
        }
    }
    
    func checkCameraPermission(_ completion: @escaping(_ hasAccess: Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    completion(false)
                } else {
                    completion(false)
                }
            })
        }
    }
}
