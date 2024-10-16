//
//  successViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 04/10/24.
//

import UIKit

class successViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
     
    var registeredEmail: String?
    var registeredPassword: String?
    var registeredName: String?
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        print("Continue button tapped") // Depuración: botón fue presionado
        
        // Aquí vamos a hacer la transición manual al ProjectPageViewController
        if let email = registeredEmail, let password = registeredPassword, let name = registeredName {
            print("Registered email: \(email), password: \(password), name: \(name)") // Depuración: datos registrados
            
            let temporaryUser = User(
                username: name,
                mail: email,
                password: password,
                fullname: "Desconocido",
                age: 0,
                address: "Desconocido",
                profileImageURL: "",
                hierarchy: .user // Aquí asignas directamente el valor de Hierarchy
            )

            print("Temporary user created: \(temporaryUser)") // Depuración: usuario temporal creado
            
            // Guardar el usuario temporal en UserDefaults para persistencia
            saveUserToUserDefaults(user: temporaryUser)
            print("Temporary user saved to UserDefaults") // Depuración: usuario guardado en UserDefaults
            
            // Transición manual al ProjectPageViewController con el usuario temporal
            if self.presentedViewController == nil {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let projectPageVC = storyboard.instantiateViewController(withIdentifier: "ProjectPageViewController") as? ProjectPageViewController {
                        projectPageVC.user = temporaryUser
                        projectPageVC.modalPresentationStyle = .fullScreen  // Presenta en pantalla completa
                        self.present(projectPageVC, animated: true) {
                            print("ProjectPageViewController presented successfully") // Depuración: controlador de vista presentado
                        }
                    } else {
                        print("Failed to instantiate ProjectPageViewController") // Depuración: fallo al instanciar el controlador
                    }
                }
            } else {
                print("A view is already presented, cannot perform segue") // Depuración: ya hay una vista presentada
            }
        } else {
            print("No registered email, password, or name") // Depuración: correo, contraseña o nombre no definidos
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCircularButton()
        // Usa las variables aquí si es necesario
        print("Email registrado: \(registeredEmail ?? "No email")")
        print("Contraseña registrada: \(registeredPassword ?? "No password")")
        print("Nombre registrado: \(registeredName ?? "No name")")
        
        print("SuccessViewController loaded") // Depuración: vista cargada
    }
    
    func setupCircularButton() {
        continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor).isActive = true
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.clipsToBounds = true
    }
    
    // Función para guardar el usuario temporal en UserDefaults
    func saveUserToUserDefaults(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "authenticatedUser")
        } catch {
            print("Error saving user to UserDefaults: \(error)") // Depuración: error al guardar el usuario
        }
    }
}
