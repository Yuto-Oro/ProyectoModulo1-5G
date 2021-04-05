//
//  WelcomeViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Orlando Ortega on 04/04/21.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: Any) {
        var salida = try! Auth.auth().signOut()
        navigationController?.popViewController(animated: true)
    }
}
