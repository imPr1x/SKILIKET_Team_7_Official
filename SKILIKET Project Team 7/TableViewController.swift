//
//  TableViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 29/09/24.
//

import UIKit

class TableViewController: UITableViewController {
    
    // Array de respuestas que contendrá los datos obtenidos desde el JSON remoto
    var projects: [Response] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300 // Ajusta este valor estimado si es necesario

        // Cargar los datos desde la URL
        Task {
            await fetchNewsData()
        }
    }

    // MARK: - Función para cargar los datos de la URL
    func fetchNewsData() async {
        do {
            let news = try await Feed.fetchNews()
            self.projects = news
            DispatchQueue.main.async {
                self.tableView.reloadData() // Recargar la tabla con los datos obtenidos
            }
        } catch {
            print("Error al obtener los datos: \(error.localizedDescription)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    // Configuración de cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        
        // Obtén el proyecto actual (en tu caso, se llaman "Response")
        let project = projects[indexPath.row]
        
        // Configura los textos
        cell.projectTitle.text = project.title
        cell.projectDescription.text = project.description
        cell.projectDate.text = project.date
        cell.projectUser.text = project.userName
        cell.projectParticipants.text = "\(project.participants) participants"
        
        // Cargar la imagen del proyecto
        if let image = UIImage(named: project.imageName) {
            cell.projectImage.image = image
        } else {
            // En caso de que no se encuentre la imagen, usar una imagen por defecto
            cell.projectImage.image = UIImage(named: "defaultImage")
        }
        
        // Cargar la imagen del usuario (si tienes imágenes de usuario)
        if let userImage = UIImage(named: project.userImageName) {
            cell.userProjectImage.image = userImage
        } else {
            // Imagen por defecto para el usuario si no se encuentra la imagen
            cell.userProjectImage.image = UIImage(named: "defaultUserImage")
        }
        
        return cell
    }
      
    // Puedes agregar este método si quieres manejar el toque en una celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Aquí puedes agregar la lógica para cuando el usuario toque una celda, como la navegación a una vista de detalle
        print("Tapped on project: \(projects[indexPath.row].title)")
    }
}
