//
//  loginViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // Verifica que los campos no estén vacíos
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(withTitle: "Error", message: "Please fill in all fields.")
                return
            }
            
            // Verificar las credenciales (este es un ejemplo simplificado)
            if authenticateUser(email: email, password: password) {
                // Realizar el segue al ProjectPageViewController después de un login exitoso
                performSegue(withIdentifier: "showProjectPage", sender: self)
            } else {
                showAlert(withTitle: "Login Failed", message: "Invalid email or password.")
            }
    }
    

        
        func authenticateUser(email: String, password: String) -> Bool {
            // Aquí se debe implementar la lógica para verificar las credenciales del usuario
            // Esto es un ejemplo. Debes reemplazarlo con la lógica real de autenticación
            return email == "user@example.com" && password == "password123"
        }
        
        func showAlert(withTitle title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
