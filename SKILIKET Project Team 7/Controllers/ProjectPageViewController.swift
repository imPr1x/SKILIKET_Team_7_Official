//
//  ProjectPageViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//

import UIKit

class ProjectPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var user: User?
    
    var pages = [UIViewController]()  // Array para almacenar las páginas dinámicas
    var suggestedProjects: initialProjects = []  // Array para almacenar los proyectos del JSON
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        // Llamamos al método para cargar los datos del JSON
        Task {
            await loadSuggestedProjects()
        }
    }
    
    // Método para cargar los proyectos desde el JSON
    func loadSuggestedProjects() async {
        do {
            let projects = try await Suggested.fetchSuggested()  // Llamada al método para obtener el JSON
            self.suggestedProjects = projects
            setupPages()  // Llamamos a setupPages para crear las páginas dinámicas con los datos
        } catch {
            print("Error al cargar proyectos: \(error)")
        }
    }
    
    // Método para configurar las páginas con los datos del JSON
    func setupPages() {
        for project in suggestedProjects {
            let page = createPage(imageURL: project.imageName, title: project.title, description: project.description)
            pages.append(page)
        }
        
        // Configurar la primera página
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // DataSource para paginación
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    // Método para crear cada página dinámica
    func createPage(imageURL: String, title: String, description: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDataViewController") as! PageDataViewController

        // Asignar los valores al controlador de la página
        vc.titleText = title
        vc.descriptionText = description

        // Verifica que la URL no sea nula antes de intentar cargar la imagen
        print("Cargando página con título: \(title)")
        print("Intentando cargar imagen desde: \(imageURL)")
        if let url = URL(string: imageURL) {
            Task {
                await vc.loadImage(from: url)
            }
        } else {
            print("Error: URL inválida")
        }

        return vc
    }


}

