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
    
    // Funcion para la persistencia de datos, esta funcion convierte el objeto user en un formato JSON y lo guarda en UserDefaults
    // Created by Fernando
    func saveUserToUserDefaults(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "authenticatedUser")
        } catch {
            print("Error al guardar el usuario en UserDefaults: \(error)")
        }
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
                
                // Guarda el usuario autenticado en UserDefaults para la persistencia
                // Created by Fernando
                saveUserToUserDefaults(user: authenticatedUser)
                // Si las credenciales son correctas, hace el segue
                performSegue(withIdentifier: "showProjectPage", sender: authenticatedUser)
            } else {
                showAlert(withTitle: "Login Failed", message: "Invalid email or password.")
            }
            
            
        } catch {
            print("Error al obtener los datos: \(error.localizedDescription)")
            showAlert(withTitle: "Error", message: "Unable to fetch user data.")
        }
    }
    
    
    // Funcion para cuando se necesite recuperar los datos del usuario, es decir, se podrán leer desde UserDefaults y decodificarlos
    func getAuthenticatedUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "authenticatedUser") else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            print("Error al cargar el usuario desde UserDefaults: \(error)")
            return nil
        }
    }

    
    
    /*
     // Created by Fernando
     IMPLEMENTAR CUANDO QUIERA MANDARSE A LLAMAR EN OTRA VISTA
     override func viewDidLoad() {
         super.viewDidLoad()
         
         if let user = getAuthenticatedUser() {
             print("Usuario autenticado: \(user.fullname)")
             // Aquí puedes usar la información del usuario
         } else {
             print("No hay un usuario autenticado")
         }
     }
     */
    
    
     // Prepara el segue para pasar los datos del usuario autenticado a la siguiente vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProjectPage", let destinationVC = segue.destination as? ProjectPageViewController {
            destinationVC.user = sender as? User // Asegúrate de que `ProjectPageViewController` tiene una propiedad `user`
        }
    }

     
     override func viewDidLoad() {
     super.viewDidLoad()
     }
     }
     

