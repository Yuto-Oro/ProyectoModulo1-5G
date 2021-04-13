//
//  HomeViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Orlando Ortega on 07/04/21.
//

import UIKit
import FirebaseStorage

class HomeViewController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var photosController: PhotoCollectionViewController!
    var secondController: NewImageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        guard let PhotosControllerTemp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoCollectionViewController") as? PhotoCollectionViewController else{ return }
//        let PhotosController = UINavigationController(rootViewController: PhotosControllerTemp)
        
        
        PhotosControllerTemp.tabBarItem.title = "Photos"
        PhotosControllerTemp.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        
        photosController = PhotosControllerTemp
        
        let controller2 = NewImageViewController()
        controller2.tabBarItem.title = "Add new photo"
        controller2.tabBarItem.image = UIImage(systemName: "plus.app.fill")
        
        
        guard let ProfileController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else{ return }
        ProfileController.tabBarItem.title = "Profile"
        ProfileController.tabBarItem.image = UIImage(systemName: "face.smiling.fill")
       

        viewControllers = [
        PhotosControllerTemp,
        controller2,
        ProfileController
        ]
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: NewImageViewController.self) {
            let userImagePicker = UIImagePickerController()
            userImagePicker.delegate = self
            userImagePicker.sourceType = .photoLibrary
            userImagePicker.mediaTypes = ["public.image"]
            present(userImagePicker, animated: true, completion: nil)
            return false
         }
         return true
       }
    
    
    func uploadImage(imageData: Data, name: String){
        let storageRef = Storage.storage().reference()
        let imageRef =
            storageRef.child("photos").child(name)
        let uploadMetadata = StorageMetadata()
        
        uploadMetadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetadata) { (metadata, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("Image metadata: \(String(describing: metadata))")
                DispatchQueue.main.async{
                    self.photosController.getPhotos()
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage, let optimizedImageData =
                userImage.jpegData(compressionQuality: 0.6){
            
            
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            uploadImage(imageData: optimizedImageData, name: "\(fileUrl.lastPathComponent)")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

