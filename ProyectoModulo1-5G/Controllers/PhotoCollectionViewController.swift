//
//  PhotoCollectionViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Berenice Medel on 11/04/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI


private let reuseIdentifier = "Cell"
class PhotoCollectionViewController: UICollectionViewController {
    var images: [StorageReference] = []
    let storage = Storage.storage()
    let placeholderImage = UIImage(named: "placeholder")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate =  self
        getPhotos()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let ref = images[indexPath.item]
        cell.photoView.sd_setImage(with: ref, placeholderImage: placeholderImage)
        
        ref.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("URL: \(String(describing: url!))")
            }
        }
        return cell
    }
    

    func getPhotos(){
        let storageReference = storage.reference().child("photos/")
        let placeholderImage = UIImage(named: "placeholder")
        storageReference.listAll { (result, error) in
          if let error = error {
            print("error \(error)")
          }
            var tmp: [StorageReference] = []
          for item in result.items {
            tmp.append(item)
          }
            self.images = tmp
            DispatchQueue.main.async{
                    self.collectionView.reloadData()
            }
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}



extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
    }
}
