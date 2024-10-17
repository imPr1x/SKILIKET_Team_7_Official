//
//  CustomTabBarController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 16/10/24.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // Función que maneja la selección de un tab
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Verifica si el ítem seleccionado es el de "Projects"
        if item.title == "Projects" {
            handleProjectsTabSelection()
        }
    }
    
    func handleProjectsTabSelection() {
        // Obtén el usuario desde los UserDefaults
        if let userData = UserDefaults.standard.data(forKey: "authenticatedUser") {
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                
                // Depuración para verificar qué tipo de usuario es
                print("User hierarchy: \(user.hierarchy.rawValue)")
                
                // Si el usuario es admin
                if user.hierarchy == .admin {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    // Instanciar la vista con el Storyboard ID
                    if let projectsAdminVC = storyboard.instantiateViewController(withIdentifier: "projectsAdminViewController") as? projectsAdminViewController {
                        print("Navegando a la vista de admin")
                        self.present(projectsAdminVC, animated: true, completion: nil)
                    }
                } else {
                    // Si es user, no hacemos nada porque el flujo seguirá normalmente
                    print("User is not admin, proceeding with normal flow")
                }
            } catch {
                // Depuración en caso de error al decodificar el usuario
                print("Error al decodificar el usuario: \(error)")
            }
        } else {
            print("No authenticated user data found")
        }
    }
}

