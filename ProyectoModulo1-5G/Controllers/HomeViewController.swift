//
//  HomeViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Orlando Ortega on 07/04/21.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let PhotosControllerTemp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoCollectionViewController") as? PhotoCollectionViewController else{ return }
        let PhotosController = UINavigationController(rootViewController: PhotosControllerTemp)
        
        PhotosController.tabBarItem.title = "Fotos"
        PhotosController.tabBarItem.image = UIImage(systemName: "doc.richtext")
        
        
        viewControllers = [
        PhotosController
        ]
            }
    
}
