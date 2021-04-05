//
//  LoginViewController.swift
//  ProyectoModulo1-5G
//
//  Created by Orlando Ortega on 04/04/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: UIButton){
        guard let email = emailTF.text, email != "", let password = passwdTF.text, password != "" else{
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                print("usuario logeado")
                let welcomeView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WelcomeViewController") as? WelcomeViewController
                self.dismiss(animated: true){
                    self.navigationController?.pushViewController(welcomeView!, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
}
