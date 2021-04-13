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

    var userId: String!
    var getRef: Firestore!
    
    var optimizedImage: Data!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profilePicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        getRef = Firestore.firestore()
        Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user == nil{
                print("Usuario no loggeado")
            }else{
                self.userId = user?.uid
                self.emailLabel.text = user?.email
                self.getName(self.userId)
                self.getPhoto()
            }
        }
    }
    
    func setUpElements() {
        Utilities.styleFilledButtonRed(signOutButton)
        Utilities.styleFilledButtonBlue(profilePicButton)
    }
    
    func getName(_ userID: String) {
        let result = getRef.collection("users").document(userID)
        result.getDocument { (snapshot, error) in
            print(snapshot!)
            print(snapshot!.get("lastName"))
            let lastname = snapshot?.get("lastName") as? String ?? "sin valor"
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
        let userImageRef = storageReference.child("photos/").child("profile/").child(self.userId)
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
        let userImageRef = storageReference.child("photos/").child("profile/").child(self.userId)
               userImageRef.downloadURL{ (url, error) in
                   if let error = error{
                       print(error.localizedDescription)
                   }else{
                    self.profileImage.sd_setImage(with: userImageRef, placeholderImage: placeholder)
                    
                   }
                   
               }
               
        
    }
    
    func logOut() {
        let initialViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.initialViewController) as? ViewController
        view.window?.rootViewController = initialViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            logOut()
        } catch let err {
            print(err)
        }
    }
}
