//
//  NetworkHealthViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 17/10/24.
//

import UIKit

import UIKit

class NetworkHealthViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViewController()  // Llamamos a la función para configurar la vista inicial
    }

    // Configurar la vista inicial según el rol del usuario
    func setupInitialViewController() {
        // Obtenemos el usuario desde UserDefaults
        if let userData = UserDefaults.standard.data(forKey: "authenticatedUser") {
            do {
                // Decodificamos el usuario
                let user = try JSONDecoder().decode(User.self, from: userData)

                // Dependiendo del rol, navegamos a la vista correspondiente
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if user.hierarchy == .admin {
                    // Si es admin, mostramos la vista de admin
                    if let adminVC = storyboard.instantiateViewController(withIdentifier: "networkStatusAdminViewController") as? networkStatusAdminViewController {
                        // Reemplazamos la raíz del Navigation Controller con la vista de admin
                        self.setViewControllers([adminVC], animated: false)
                        print("Navegando a la vista de admin")
                    }
                } else {
                    // Si es usuario normal, mostramos la vista de usuario
                    if let userVC = storyboard.instantiateViewController(withIdentifier: "networkStatusViewController") as? networkStatusViewController {
                        // Reemplazamos la raíz del Navigation Controller con la vista de usuario
                        self.setViewControllers([userVC], animated: false)
                        print("Navegando a la vista de usuario")
                    }
                }
            } catch {
                print("Error al decodificar el usuario: \(error)")
            }
        } else {
            print("No se encontró data del usuario en UserDefaults")
        }
    }
}
