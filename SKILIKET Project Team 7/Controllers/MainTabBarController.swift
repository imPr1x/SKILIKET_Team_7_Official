//
//  MainTabBarController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 16/10/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self  // Establecemos el delegado del TabBarController
    }
    
    // Método para interceptar la selección del Tab
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Identificar cuál es el tab "Projects"
        if let tabTitle = viewController.tabBarItem.title, tabTitle == "Projects" {
            handleProjectsTabSelection()
            return false  // Evitamos la selección automática del tab
        }
        return true  // Para todos los demás tabs, permitimos la navegación normal
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
                    
                    // Instanciar el NavigationController que contiene la vista de admin
                    if let projectsAdminVC = storyboard.instantiateViewController(withIdentifier: "projectsAdminViewController") as? projectsAdminViewController {
                        
                        // Eliminar cualquier vista anterior (de "Projects" por ejemplo)
                        for child in self.children {
                            if child is UINavigationController {
                                child.view.removeFromSuperview()
                                child.removeFromParent()
                            }
                        }

                        // Agregar la vista de admin como un child
                        addChild(projectsAdminVC)
                        projectsAdminVC.view.frame = view.bounds
                        view.addSubview(projectsAdminVC.view)
                        projectsAdminVC.didMove(toParent: self)
                        
                    } else {
                        print("No se pudo instanciar projectsAdminViewController")
                    }
                } else {
                    print("User is not admin, proceeding with normal flow")
                    // Aquí, para usuarios normales, dejas que el flujo siga normalmente con la vista de "Projects" en el TabBar
                    self.selectedIndex = 1 // Esto asume que el segundo ítem es el de "Projects"
                }
                
            } catch {
                print("Error al decodificar el usuario: \(error)")
            }
        } else {
            print("No se encontró data del usuario en UserDefaults")
        }
    }
}
