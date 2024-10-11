//
//  LoginRegisterViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 01/10/24.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
    }
    
    func setupCircularButton() {
        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        registerButton.heightAnchor.constraint(equalTo: registerButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.clipsToBounds = true

        // Asegura que el botón tenga dimensiones iguales para que sea un círculo perfecto
        loginButton.heightAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true

        // Configura el radio de las esquinas para hacer el botón circular
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
