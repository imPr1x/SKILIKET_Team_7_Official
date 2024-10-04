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
    
    var usersData: [User] = []
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // Verifica que los campos no estén vacíos
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(withTitle: "Error", message: "Please fill in all fields.")
            return
        }
        
        // Llama a la función que obtiene los datos y autentica el usuario
        Task {
            await fetchUserData(email: email, password: password)
        }
    }
    
    // Función para autenticar al usuario
    func authenticateUser(email: String, password: String) -> User? {
        return usersData.first { $0.mail == email && $0.password == password }
    }
    
    // Muestra una alerta
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // Obtener los datos del archivo JSON
    func fetchUserData(email: String, password: String) async {
        do {
            let users = try await Users.fetchData()  // Llama al método que obtiene los datos del JSON
            self.usersData = users
            
            // Verifica las credenciales del usuario
            if let authenticatedUser = authenticateUser(email: email, password: password) {
                // Si las credenciales son correctas, hace el segue
                performSegue(withIdentifier: "showUserProfile", sender: authenticatedUser)
            } else {
                showAlert(withTitle: "Login Failed", message: "Invalid email or password.")
            }
        } catch {
            print("Error al obtener los datos: \(error.localizedDescription)")
            showAlert(withTitle: "Error", message: "Unable to fetch user data.")
        }
    }
    
    
    
     // Prepara el segue para pasar los datos del usuario autenticado a la siguiente vista
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "showUserProfile" {
     let userViewController = segue.destination as! UsersViewController
     userViewController.loggedUser = sender as? User
     }
     }
     
     override func viewDidLoad() {
     super.viewDidLoad()
     }
     }
     

