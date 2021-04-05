//
//  ViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Berenice Medel on 04/04/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func isLogged() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                print("Usuario no loggeado")
                return
            } else {
                print("Usuario loggeado")
                self.performSegue(withIdentifier: "WelcomeView", sender: self)
            }
        }
    }


}

