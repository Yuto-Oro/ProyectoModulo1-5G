//
//  ProfileViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Berenice Medel on 12/04/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MobileCoreServices
import FirebaseUI

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userID:String!
    var getRef: Firestore!
    
    var optimizedImage: Data!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        getRef = Firestore.firestore()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            self.getPhoto()
            if user == nil{
                print("Usuario no loggeado")
            }else{
                self.userID = user?.uid
                self.emailLabel.text = user?.email
                self.getName()
            }
        }
    }
    
    func getName(){
        var result = getRef.collection("users").document(self.userID)
        result.getDocument { (snapshot, error) in
            print(snapshot)
            let lastname = snapshot?.get("lastName") as! String ?? "sin valor"
            print("documento: ", lastname)
            let name = snapshot?.get("firstName") as? String ?? "sin valor"
            
            self.nameLabel.text = "\(name) \(lastname)"
            
        }
    }
    @IBAction func uploadPhoto(_ sender: UIButton){
        let photoImage = UIImagePickerController()
        photoImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        photoImage.mediaTypes = [kUTTypeImage as String]
        photoImage.delegate =  self
        
        present(photoImage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let optimizedImageData = imageSelected.jpegData(compressionQuality: 0.6){
            profileImage.image = imageSelected
            self.saveImage(optimizedImageData)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func saveImage(_ imageData: Data){
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.color = .red
        activityIndicator.center = self.profileImage.center
        activityIndicator.startAnimating()
        profileImage.addSubview(activityIndicator)
        
        let storageReference = Storage.storage().reference()
        let userImageRef = storageReference.child("photos/").child("profile/").child("my_photo.jpg")
        let uploadMetadata = StorageMetadata()
        
        uploadMetadata.contentType = "image/jpeg"

        userImageRef.putData(imageData, metadata: uploadMetadata) { (StorageMetadata, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if let error = error{
                print("error: ", error.localizedDescription)
            }else{
                print(StorageMetadata?.path)
            }
        }
    }
    
    func getPhoto(){
        let storageReference = Storage.storage().reference()
        let placeholder = UIImage(named: "user_icon")
        let userImageRef = storageReference.child("photos/").child("profile/").child("my_photo.jpg")
               userImageRef.downloadURL{ (url, error) in
                   if let error = error{
                       print(error.localizedDescription)
                   }else{
                       print("imagen descargada")
                   }
                   
               }
               profileImage.sd_setImage(with: userImageRef, placeholderImage: placeholder)
        
    }

}